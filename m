Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6464A27E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiLLNzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiLLNyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:54:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83EDB9B
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:54:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC98NAT023594;
        Mon, 12 Dec 2022 13:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XoIHVONvILEaKy+HbpmTBS+UiB014vARZ0NIjq+OaJc=;
 b=0K/QhqgmWhYjQSFdrSawHK5Q131P6PlJ17UGz6T23hHpBCZ4otrfgrApV4ToUHK/dTJM
 atPotDHPiprlwQiDzvazIQsMUEKws/E2KDIYn7KlbtRg/gkkvQbL+Kp3EWN6QgbTFIC7
 GDusXShUVFbatW9lEXyc5SUelGYzGjs+1G+labGs9+Y7XVeFmcSsUduVt6DnWjt1FQus
 1stvTfoQSncNg8uDGuERKxfgWH3YwbskfSWoJKac391P1aWUXfZV/e3wT2jTfOg0gMhl
 +8D7PmV9rWEqpn/YVN0WpiJu8q+cuGU9dCq0pFEu3cXtsm982YtI6KoW4KY9c4wTwMlv yA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj092quq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:54:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCBvmSU031750;
        Mon, 12 Dec 2022 13:54:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj426s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJF7lesbawD8pEWGDWX8xA2UWk/sADoMGvA92MOxeU98tzqRba7luBnDAmbBJ/Gc2s8/0bayiXWGVUtUg10stAvIzinLvNv/Bn3TOkxXym9b4IU7DJgfmtCEYT9Tt2o39m0eAmuBWu1NW5nCs7uLyHcWe4rtt8UivVnx4yf24mOsZKqpT0psJ6MdBmuuKfjiYqMvQC2ZZoY4a7ArO/WX/4xT8J0uwWzmAimsiz/dkqhnApqjoS+d26/MMWbV6gD4lp3unRTBDinqQmyPE/sElyDm+DjQsYI+BMHiJfGrU65k8qCS+jW3ZQZuQDAysQer12on63Xtj9jQ2HE/r0oObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoIHVONvILEaKy+HbpmTBS+UiB014vARZ0NIjq+OaJc=;
 b=eNnAhkonivmiVH445Ebvkw6FmzkyMWaDwxqsc6oej8fMm6P/X/xnhWxVmA2ch05ZIwXZ8eR+wStR8u5jftgHGgjnskNQKTCUewcPsMH1YZwM6oRNpKEDP1Sy/T9xCB9w4DmilWOVlEHX+mqh7odRmXw85dF6d/7zxYTLg/0wbYmWEeYKkFSasj3tL4x7TXdKn5ktjqigt8Re7RpKNLrg1GjFpfiH9nxkBFPju/KxoPY37T9t82seJmcQXm+S9d2fniaoeq03MpSnSy7GqaoY3wS4nGRqW97V3hiBmlGrY0RQRIBkLKlOwnz8jl9dbFiQLdr1e0feoapK4smVIG+ZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoIHVONvILEaKy+HbpmTBS+UiB014vARZ0NIjq+OaJc=;
 b=TKqE3cio8x5dyWs5m1VTMKE3CFqRlDNT25TjMW4FajFWOMeFWvWRkUbka2c94Q8FXnP98zzMC40tV62OSqpDaR+spbXbhePFMdPVXsZJupRJq1Jg4Cou5yCEH42t4WQW7Um04Pp7A9s28RBMsx0++0OKahJUpcsF9db0jt7748o=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BY5PR10MB4163.namprd10.prod.outlook.com (2603:10b6:a03:20f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 13:54:33 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 13:54:32 +0000
Message-ID: <8780344a-0f81-b39a-998b-09707df2372c@oracle.com>
Date:   Mon, 12 Dec 2022 08:54:30 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com> <Y5cqAk1/6ayzmTjg@ziepe.ca>
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5cqAk1/6ayzmTjg@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:805:106::21) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BY5PR10MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df258c6-107b-47da-a0a9-08dadc4865a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHMNBUbn02/pGXEiFEf+SV+CCOcIhstnwnuGLCHKcbZ81b7MB+wzoH1UZe30oyCM1MTDd6w+3npnAyve1P64r7ylGdbBgH745vte1Otn45RykSt8prLstsoidU1ttGhJ2Du5G0GUp96gelEvBtiVZa1HyNnPFtxzhvqLKMYk1TB7+5Hot0+2BHRyNgtKZNqMjF67u3brM3ev2px32L+36+oLdGmfVNCBwVuxlwaZg8roJFsIt6IA8iDaJxGW3+4cEARIaFh2+NE/lj5+U1Gtqw9GtztswrfdaCPfaJVYXxkqGlnN97GZFsMViX9MiggDtIZrC12vVFObv4UzOxkSWzOH2+r11fko5ZMg7CrC5COfP0fQkpyXQ4RgNck/SYRIEHfSLmKKhtSvlbGenlva9fhXf9U08BsBV0raOJbGXUlN8zq9RiO9ma3qNS/Ucvj43qXBCxknvGmnaSopi6YQ1AbLmoBt9r2YfFTm4eQ1riT2jibL4s9z43mZVjUu/yWFMJyzInaLk+e85bq7YhZ+C13qTGAWhFgaQefQMbV1yDEx5sfA6TnoV7YqpF/M9osj1R3IdeSTQ1dyZaotZD7JD7twYTIUKej1nIs6yuRp6XG0I0MO0uZ7QDEsSQltMxl49qIccMyx709uvyjs+/UCQh1L0Vwft7m7M9SbkhsPlGcnD9137S4zJjtpe+4wxTHTWn6q2gM3/MSHLW56gUIZHG4QWSMnu6uva9JKTLWoGJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36756003)(86362001)(31696002)(15650500001)(6506007)(2906002)(53546011)(41300700001)(5660300002)(54906003)(4326008)(83380400001)(6916009)(66556008)(316002)(66476007)(8676002)(66946007)(186003)(44832011)(26005)(8936002)(2616005)(6512007)(38100700002)(6486002)(66899015)(36916002)(31686004)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTJudTBDMHovenVNK0VIcnhIdW1JRk9hTGsycXZicDJMalU1MnliUTVsUTZp?=
 =?utf-8?B?T0pzTGQreSs2MC9RSER2bXBZZmhja1Nub1VoSjBXdDkrNXNoc2FvSkw3UHVV?=
 =?utf-8?B?WkNXZ05HYW9sUTNwRVN2WGZ1R05lajZ4TzQyWTYzZkJNN01hSzBydTArQldD?=
 =?utf-8?B?bTFhd1lxSFB0ZnBkNWd5aUNRckRnZWt0WUtoUmgxSXA3RDkxT0pqRXVoM2lw?=
 =?utf-8?B?NlhZSFlNNUN3ZWt1NVBGTzc5Qi9PWU9hVnROVEc1RVh4WjVSc3FJTXV2WGN3?=
 =?utf-8?B?dGl2dHNrcVcxWC9Nb2ZoTUZDcGltbG5FZTV5bWNoNHJVQTh0SzVGRlprQ0JQ?=
 =?utf-8?B?azNpUmY3d3RMaG1hb1grTEM2NVZTZEVuODZTa3RCWlBFR2ZsR2laekZ0UlBV?=
 =?utf-8?B?Wit3RGxLK1J2ZGFpMlVraHVGbnk0bCtTT3Uyd1R3dHVDbUxLWjdENTEzUU56?=
 =?utf-8?B?dUJBeERzS3ZTSHFhc2Zac0ZUN2NVYjJDOUN6aVFDMnl6bEJHaXJiMWlXM0F6?=
 =?utf-8?B?TFVhc005am1aMUp1K3VrQjF4NHhrd21HUmhYMzd2KzRpUmkwOHZOZWprWkNP?=
 =?utf-8?B?elRtN2hxZVF1VzMvbzBnVDJPYU4vUnNUc092VHJQYlRUZnFna2VmbmpxQ2hi?=
 =?utf-8?B?RlFkQUZLTnFpOFFWVnZGdWhpcjF3QUNkaEc0M05JajhnMWQ1VFh6bGZEYU12?=
 =?utf-8?B?bktDYjcvc3p4Q3BMbnZpSGF2VGNrNEt4dUV6MFlEakp0SEZLRkhVNlc4aCsv?=
 =?utf-8?B?a216VElyOVZVQ1RwUUw0ZnRmclBldDlqaEhldkVVMnJKZWZ1cCtnVVNoWTRi?=
 =?utf-8?B?RTRiQTV2MEx4b1RTMnFLR0VPb3JPKzc0S2lUMGNlOU9TZDZLZmw2ODVtMEQ1?=
 =?utf-8?B?eG9PN29QNDg0T0JTbkNMNkVxeGRBR3dYcmRzVjVZY3REa29mRlFpY3Q2MHNG?=
 =?utf-8?B?OFV1alJmVW15TnZTYUZDSUFZSWdTWmY3VWlnMU00T2l6TC9WMTBhV3VFNE44?=
 =?utf-8?B?NytueVpUbnBSZnBtbkM0L2ErSzlNWmYxejh4cWlWdHlXTnlYMGdXYVBaSXFh?=
 =?utf-8?B?UUpkY00wRmo0ak56ZjliWVRBOER2dEZKaVZDZURyZkxuUTVVdVRIV3lqK3V1?=
 =?utf-8?B?c3VldnQzb1FpUjBqUkx0N1EydURzMitQdzVtVEMvbzFweEpkdDZtUE9HV3VV?=
 =?utf-8?B?eEJjRmZoU2xqTWlJOVBDVVd0d09tSCtKeUtQNllBNkN6K1p4b0NXcXZuZWdw?=
 =?utf-8?B?c1NxZDIzVURwRXRyVUEvcVRMZ3IzK2psMUcvNU5adFhSNGlPbzBBUXNyd0dD?=
 =?utf-8?B?WTRVaWEvOEUrQXJPd0JvdE84anNmT0hzbGwrbHBKSmRlcVByK1ByZUM3cXRZ?=
 =?utf-8?B?aXM5UTRtU2NmTnlMbXBlOGxTZ0NuZkw5NVc4SlkxTTU1aFplYnYvRExpbXNW?=
 =?utf-8?B?ajFWNmkwWE9iL0pEbG82MEJPaXg3aWdPOEZWa3NXOUpPSTJ1ejRIRS9mSWxI?=
 =?utf-8?B?SXJRMHAveGZhWEJmUHBVd0swLzZ6WHJjZ29YYTVFeEliTXo1NWxRZDJ6enN3?=
 =?utf-8?B?THRZZG56L1oyT2RpQ0pIV1hKZVRCSWZPZjRBMnlyckF3L1FhSit4QlJzQ2t3?=
 =?utf-8?B?NTBiaWtJY3AybkJVblpXak9HcUNIT1NGZ2ZUeG9aVmZBTzd5TjNPRjZ5WmN6?=
 =?utf-8?B?Q1AvZUlWV2h1SEVSY2pGdVgrZys4dndaNXdUc0VBeWpTSXJUMU5UUkVHNGtw?=
 =?utf-8?B?ZjVzZng0cWt0aWZNOVpldkRxSDBJWUJNL0toQVh2N0FsWkM2M2JZRFF5cDc3?=
 =?utf-8?B?L0F5NmtsK1k0d1RpaE4rc3VveWYybVBwL0E5MGFGaE1PRmFSazlQOVdDMnhH?=
 =?utf-8?B?OTFFaFV2QzZselJyK0VxYlpNZmZNQTM1ODRuem9vWFA1QTFKSWdNKzV5QzlM?=
 =?utf-8?B?aE55cmtBTThPZHZ4c1l2QTl6cVgyNE9HRzZTZXpnREhacS9YTFE5Y0sxV2FT?=
 =?utf-8?B?VDRudGFZRmNJa0FpRFEyU25RTHFJV0UySlBSbnU2eS94VmV6Z1l6TDhabzF6?=
 =?utf-8?B?RmNianFUN3Z5cVpOdGc2RzJwVE1OMWRpWGloeVJWSGNTcGhyTk5CMndQandm?=
 =?utf-8?B?alhTOEFkNmErMFo3V1pRM0xUTUlhNktKWnNFcFVwdzd1SmRPeURjTFlycGVD?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df258c6-107b-47da-a0a9-08dadc4865a7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 13:54:32.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YajZk4e9b20ggOa13LAWHOOkHDaYPZ8bh1/jxgdyKDBq1QLe09BtTOHzh9phWvBTPwtpLeygamgbXTc1VZvL0rZcxE8gda/sVFO0c9YRjyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=590 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120128
X-Proofpoint-ORIG-GUID: uscw-9qczpsRHzkn5eEcZQrd1m0kJP6z
X-Proofpoint-GUID: uscw-9qczpsRHzkn5eEcZQrd1m0kJP6z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/2022 8:17 AM, Jason Gunthorpe wrote:
> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> 
>> Thank you for your thoughtful response.  Rather than debate the degree of
>> of vulnerability, I propose an alternate solution.  The technical crux of
>> the matter is support for mediated devices.  
> 
> I'm not sure I'm convinced about that. It is easy to make problematic
> situations with mdevs, but that doesn't mean other cases don't exist
> too eg what happens if userspace suspends and then immediately does
> something to trigger a domain attachment? Doesn't it still deadlock
> the kernel?

No deadlock.  Any ioctl's that need vaddr return EINVAL if the vaddr has been
suspended.  ioctl's that do not need it succeed.  The vaddr is not needed when
all pages have been pinned, because iova can be translated via the iommu.

> Honestly, I'm not sure I see the big deal, just don't backport these
> reverts to your disto kernel.

It must be done every time the kernel is refreshed, and is disruptive and 
error prone.  All exceptions to the normal process are. And it derails my qemu 
patch review until native iommufd support is pushed into qemu.  If I can avoid 
those problems with a few simple fixes, then that is a win.

- Steve
