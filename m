Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41B3648F25
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 15:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLJOOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 09:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJOOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 09:14:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0313F49
        for <kvm@vger.kernel.org>; Sat, 10 Dec 2022 06:14:14 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BAB8rRb004037;
        Sat, 10 Dec 2022 14:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dsl3ux5UeQII7+deeoLa/F1QGJ+KXdztRrHOQdA9jxI=;
 b=KdMtPuFd59NvwLZT9NVc8VJ/xc2Wrf8C7tGpealjGdBOW8tsYM50Rrc9ddpXc0ewwiHB
 Oo23ZgSvnNvuiK+TzFd8cksotebWzS0N/18K4BBYw+v/e8jtaALxY9HALAbJ6LBU/FLf
 ancnZ7Ps3z6UpG2x0Sp+PrXh2rmtMCwNpuZ57appEp+MPhtib34oV9djyUyLsLILHsfa
 kq2YfsVS9FQPJzg+Dur+Igv+ZQvlDc12Cjgg//y+o31s0MC5zZeBOcrAW7fXIB4L8wYu
 GHJqHf5H70cWE+Y8KrbpimdQ9kmMhUnLpj9QX0Cv0IxEh1VLz8P3mgKfV4qUGqyGhUVS 2w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgq08gd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Dec 2022 14:14:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BACUHhs031178;
        Sat, 10 Dec 2022 14:14:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj1rucp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Dec 2022 14:14:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTKl32azZ0HE2RwS478kL3EjM2Qgg+4TAGIIek4yILFjgQKNpCTZyC/3gPI7YV+j2DkRpXBpTWLpTRAOEexQPy5isrw1KxSxgYCxOadPlkLDnt5zeLIk/Bp8Y7/n9oAoVWlx+RTOK2+GT88ZxHEjEdLeueXUXVgqBbWSjLM1ELVw1tdme+TOy/ca5RP7XjA/UC79BEUTrPfMRocnKIil8f9PPmt0TWXrRrxgBTMUj6M3SpvcxM6n1ECRNaYRWUrbW/UwNYeAwYvexQ2OEXPhgEnBx7ZWsf9ZUtQAK7lJuAx3PNOwrB50FSdvjLUraxIdQKJ8RfxVDzeM+6AHhd2WCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsl3ux5UeQII7+deeoLa/F1QGJ+KXdztRrHOQdA9jxI=;
 b=VbUILIaz8ocN+9KuSG1+eXzYfoDBohhpk6ZjIf6DyElCCkI9us25wydoH+6DKA1FYDUJJy7SwppBZvUTNAT3CM29kyyR3Ul8fzG5KtWEEeTza79CpSg/uMLbsIjNzIp6yt9UvkakiN6RJQucZp043cUdjyhNhdwZfKzCaRLQGCb+n2ntJLkU15HX+5GgC1rYh/viFruHz5WDswzW1a8RR0GYK0EWDYzWxClGYp86rDVs3RtVeXFzL64pprKXPZ28igWRezeBAy7uV81s08jrNAebFNcmIlGa+LCOUvFvCxDu4AFeJ7DfoZ6QKs9ggWfMi2X4VhNvB0pnxqkm6kcgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsl3ux5UeQII7+deeoLa/F1QGJ+KXdztRrHOQdA9jxI=;
 b=mQPRrHp9lzJqSa4cf1siwe7wrRh+MyH1FJRayRzmzeIvM01/AzMQP/0bY1x0fwsnleogD4S0cvtUNb8IqSYWA4DVzGYPvC0JNGU+phlQiNe7J7W0mrL4pbzTTP8wVbtoFAwGbfMJaZKaZzkVmNMWhxn/Jnm7w2Hsd/OUCED4uUU=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CY8PR10MB7367.namprd10.prod.outlook.com (2603:10b6:930:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Sat, 10 Dec
 2022 14:14:08 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Sat, 10 Dec 2022
 14:14:08 +0000
Message-ID: <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
Date:   Sat, 10 Dec 2022 09:14:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209140120.667cb658.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:806:f2::19) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CY8PR10MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: d6525884-8b44-48d4-3aa8-08dadab8cd72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHxZz2YBvIsfR3GanZv06ACGJvZJoGrbDRXxWgVzukr5NBs27ypXHdELBfYw/FWq++IfT3ntnvsPJW7kVs+ui/LedsD+pWZV1XsZPOGcooLti6dL1xzgd4m0QLc/0O3tMzVzm3YOzPaIsuO+LAWPevlgJbuAk9D8vb9Jp8V/qfJEAL02O4Hf3z7jauOXoVK4/RtGJmUmTxt/Azw7PjaEXGLPpCtKhjaaOGNh4jj7k2Wi1/B2tlVDCynKC0syLctjivr3UHY1C9sYME0sl8EXafIFfvQFIoHR+BQzlqNM0TFoQYf7ccxVyiBIl6zl8ncuyC2SJME1rxZMp03zskCANa0S3JkwK2a46DSEEJdyVJ+5RH2YIzaeAl3ldVozA9StyforDCyMUGdiq/MeC+HnGfg+eoATFEWslcaAjZkc5LQDol2k74MzjJYkooXaNCu0+H7PXcQxH5V8u9RD974Z8YZIrli1ahNWDGX+cyn9GCipd6QkPyKy/aOnKVTksCUX0w30F9zvXzaYDyP3ilpfWfLfwUeRPhm3dU1g93alqpfzS2GOS5Eo92uYPzqa3TJqswRqXv7Pio8rZToLY/Mwz69EqeXyEGz8Y81EI68/ALnVgfC58bkhQCT7sFiYSu/h+tRQO5K+8vOM4/Ji2ennFE+594GE4RHlF5V8b+Gs4seBpoWAR1gV0p/Eg3GLJs78bBtmFdScl6w1c9aCF2BFk+QJlx4G4PdULA3G65uadHeRm8DWQNH8uRj5MjH0LPam
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199015)(6512007)(26005)(2616005)(54906003)(316002)(41300700001)(4326008)(8676002)(31696002)(38100700002)(66476007)(44832011)(66556008)(6916009)(66946007)(478600001)(6486002)(83380400001)(36756003)(186003)(53546011)(86362001)(15650500001)(2906002)(31686004)(5660300002)(6506007)(8936002)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDhmNmFjWEt4L205NTNDR2hYcDd3NzM4emZJcWFrRmNRRzFHY1ZWM3Z2SGxD?=
 =?utf-8?B?ZURHSGtSTVgzYUZxZGNpeUg5dEo3RmhOeEUxd2grS1dBbUl6ODhYNVBaK1BN?=
 =?utf-8?B?V01TYlRsTzNldmlobGtkaEc5WldzT09zY0o2VnpIVW9PVUZsOEsyWjVUT0k4?=
 =?utf-8?B?YTh2V1cyT2w2OW9JdGoxSktpajVOWkhiRi96aldKVGJCNGpuWXVEOGdLYjdp?=
 =?utf-8?B?c1JKTjdHWDBSVlgrK2tUbDljZUpoR0J0SVd3RWhZTHh0VWxOeTEyWGw1a3VR?=
 =?utf-8?B?UHZiTzBpY1pXa09Jd3diMktaK0E2aERTYng0Y3dKME1yam83cEQ5SGIyRmt1?=
 =?utf-8?B?NTgvdEpsRUZ6d3BRQTNlNG5xeTVOMEVYdDBUOVZna3RycnpBZEt5WWVuUHp6?=
 =?utf-8?B?d1BGcTJhUlBJZm5UczJXVDREU2oySys5QzFud28rTmtxSHZrNUxJY1dFRVp2?=
 =?utf-8?B?bys0MFJTZEVHVWNtOXppcjZndU9BZXZTR3lpcUFURGlvUTN1azVTR25UWGNo?=
 =?utf-8?B?UkVBcjg1QnVSbi8xRFV4bGNlcmZwYlhuOTVvQUFaK2lYN1dldkRtcitZdEFl?=
 =?utf-8?B?R0x1TnJoYzYxMFd1VWF1NmdIV3grU2xEeVNuZDFVRm5QNi96Tk5xVTc3d2dz?=
 =?utf-8?B?S1dyVThxajVwc2crYmZZL0RNODRXTUoxSGxXLzhNU3FqazY5bmpNRjkvR2Ey?=
 =?utf-8?B?c2VvWHVySWdhdW1uMkFTbFN4L1Bxdko2RXRWWVdPQzI4bkdqL3BuamZZUXFv?=
 =?utf-8?B?TTBSNW9SbVVGT0NXZXM4dUUrRkVvdVJxckpEWnU2c0JRS1pWMWxUem1pYTlq?=
 =?utf-8?B?WkxPMGZpQXkxT3E4Y2t4RGk4OVJ5eU4xak9zanhjNnNLMHEyWE5DUlFhN3Fa?=
 =?utf-8?B?dlhGVTZnK3lXY3p2VTZad1l2TU0rMWFoMVVHd3UvR3I5RVRUc3ZGTGZnaHJ4?=
 =?utf-8?B?dU94ZlBMbWV3RG9URC9JR0wxVEgreEFvYXdkdlBCZGx1TGdWeEpNbFZXWkpI?=
 =?utf-8?B?ODZ0SzN6cWhYdmFBNG1FT2xOcFFrWFJjZk9vY3ZUUkJnMFRRMlJtbmpyV3V5?=
 =?utf-8?B?WThyZFpBUkJPVlBTMFhiMTN5M1QwOWlUUDQ2RmZLOEM5Yzl3MFQ2d2UyaW54?=
 =?utf-8?B?dHpCRDdyZEMvTDEveUlKQmhTTUpiMlVkbWd4bVJwMWxwUkYxdEh2UlVjTG0y?=
 =?utf-8?B?ZFYrUktlU3RyRjN5a254NFhwbThiNTRoWWFqRm9PdHhqVmdPaTFydUpnQ1Jx?=
 =?utf-8?B?bEV1RTZTTDFaODlYL2h3MVlGb0J5TkFQYXN0L0h6eDZiQTU1b1NGZ3B2eVE4?=
 =?utf-8?B?MW9LeXY5Rkh2bEwwdXdLZisvSzBmT0xPdFhqTmdoSnN3ZzFHNTllaTVNVmxz?=
 =?utf-8?B?VVUzR1VmSEZBUkpxdUVsQzR6cnJId0JLVFhhMmhFMC9KU1Q1WWJRZHpwbzg4?=
 =?utf-8?B?TXIzNjUvK3lIVUlDc3NqczdnRFFtaFMvWFJXSDlRa3liVWFXd1dPelluUDRn?=
 =?utf-8?B?SGI3VUxaVzkzT256RVBZaFRKMFptRHVZTVdlT3A3cFRzZFpQMGk0VnQ5WEpC?=
 =?utf-8?B?a2k4ckFqTCt4bnplSXYrS0F6QTB1VUZMVU1CTDJzZFNYRVRNQWU5cmNOa1NQ?=
 =?utf-8?B?azZjdmp3RDdXOHNIUHdzKzFGejRYb0lMdmFGbHJ5QVc3NnJ4ZVhWMVRjb0JX?=
 =?utf-8?B?N3N3L0FYaWtiREkxTFVXRDJnQXBkVVpkckJKUnJ3NGY4Tm51cGhoRHdFdmFi?=
 =?utf-8?B?Uy9uK05sTGpqSDJINGZDZTRPd3J4VDRZdFRGOVYyOERtb3Z3YU16UURRNEx2?=
 =?utf-8?B?d1l2RGh2RE54RkE2czFoZnEyVFBDTzhMZFRXOHRGYk1IbFJ4SzRkc2tRR2Fy?=
 =?utf-8?B?S3ZuMkFzY0RIdkRQRDFFVkZrT2RRUjFXSzNvTStua3Y3WEZwRVByNHNnZnJU?=
 =?utf-8?B?UjlPTkFtWG1kZ3c5S05TVEVKaUVsUk9pQTRHbEd1QlVUT0YvRWpRbFkrVXJr?=
 =?utf-8?B?Qk45WExwZWFFU21vSlBtVFR3WVlrZkg2WXA0S2ZDNk1DcGJ0c0JiZTdVdjZS?=
 =?utf-8?B?cWZ4Tm9Bc1ZkYmxVNDNIdDVDK2YydHI5cXhKNDdwT2Y1NjRFd0txOHMrTFdp?=
 =?utf-8?B?ZHhZdmNRanM4SjdYY1dtK1FRMW5vbDgvanRWcklaMXZWMkM5cU1ub0R6OUNF?=
 =?utf-8?B?UVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6525884-8b44-48d4-3aa8-08dadab8cd72
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:14:08.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhyol3aS5us4MPf3a/OEyWTKP3DbIp04TYkn76hKGfkyHcZAmMgMzGsEpf2iSoZ7vGD+WZgcWdPzgaAq7a9jSWgqrJ4A9Q84R8G/HC7j7mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-10_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212100128
X-Proofpoint-ORIG-GUID: 4o9yU_LQlur8cA_g6v1nSDS5j0lNbXVR
X-Proofpoint-GUID: 4o9yU_LQlur8cA_g6v1nSDS5j0lNbXVR
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 4:01 PM, Alex Williamson wrote:
> On Fri, 9 Dec 2022 14:52:49 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
>> On 12/9/2022 2:42 PM, Alex Williamson wrote:
>>> On Fri, 9 Dec 2022 13:40:29 -0500
>>> Steven Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> On 12/8/2022 11:40 AM, Alex Williamson wrote:  
>>>>> On Thu, 8 Dec 2022 07:56:30 +0000
>>>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>>     
>>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>>>> Sent: Thursday, December 8, 2022 5:45 AM
>>>>>>>
>>>>>>> Fix several loose ends relative to reverting support for vaddr removal
>>>>>>> and update.  Mark feature and ioctl flags as deprecated, restore local
>>>>>>> variable scope in pin pages, remove remaining support in the mapping
>>>>>>> code.
>>>>>>>
>>>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>>>> ---
>>>>>>>
>>>>>>> This applies on top of Steve's patch[1] to fully remove and deprecate
>>>>>>> this feature in the short term, following the same methodology we used
>>>>>>> for the v1 migration interface removal.  The intention would be to pick
>>>>>>> Steve's patch and this follow-on for v6.2 given that existing support
>>>>>>> exposes vulnerabilities and no known upstream userspaces make use of
>>>>>>> this feature.
>>>>>>>
>>>>>>> [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
>>>>>>> steven.sistare@oracle.com/
>>>>>>>       
>>>>>>
>>>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>>>>
>>>>>> btw given the exposure and no known upstream usage should this be
>>>>>> also pushed to stable kernels?    
>>>>>
>>>>> I'll add to both:
>>>>>
>>>>> Cc: stable@vger.kernel.org # v5.12+    
>>>>
>>>> We maintain and use a version of qemu that contains the live update patches,
>>>> and requires these kernel interfaces. Other companies are also experimenting 
>>>> with it.  Please do not remove it from stable.  
>>>
>>> The interface has been determined to have vulnerabilities and the
>>> proposal to resolve those vulnerabilities is to implement a new API.
>>> If we think it's worthwhile to remove the existing, vulnerable interface
>>> in the current kernel, what makes it safe to keep it for stable kernels?  
>>
>> I do not think it's worth while, but I have stopped fighting for 6.2.
>>
>>> Existing users that could choose not to accept the revert in their
>>> downstream kernel and allowing users evaluating the interface more time
>>> before they know it's been removed upstream, are not terribly
>>> compelling reasons to keep it in upstream stable kernels.  Thanks,  
>>
>> The compelling reason is that stable is supposed to be stable and maintain
>> existing interfaces, and now I will need to re-merge the interfaces at
>> regular intervals when we update UEK from stable. Oracle is a current user 
>> of these interfaces in our business. Do we count?
> 
> These are the rules for stable from
> Documentation/process/stable-kernel-rules.rst:
> 
>  - It must be obviously correct and tested.
> 
> (check)
> 
>  - It cannot be bigger than 100 lines, with context.
> 
> (We're pushing this a bit, but we could certainly disable w/o removing
> the interface in far fewer lines.  We're close enough that I think a
> direct backport is preferable)
> 
>  - It must fix only one thing.
> 
> (check)
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 
> (This is a point where you could present an objection)
> 
>  - It must fix a problem that causes a build error (but not for things
>    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>    security issue, or some "oh, that's not good" issue.  In short, something
>    critical.
> 
> (This as well)
> 
>  - Serious issues as reported by a user of a distribution kernel may also
>    be considered if they fix a notable performance or interactivity issue.
>    As these fixes are not as obvious and have a higher risk of a subtle
>    regression they should only be submitted by a distribution kernel
>    maintainer and include an addendum linking to a bugzilla entry if it
>    exists and additional information on the user-visible impact.
> 
> (N/A, but note the mention of a user visible impact)
> 
>  - New device IDs and quirks are also accepted.
> 
> (N/A)
> 
>  - No "theoretical race condition" issues, unless an explanation of how the
>    race can be exploited is also provided.
> 
> (AIUI, the vulnerabilities here may not have exploits, but they are real)
> 
>  - It cannot contain any "trivial" fixes in it (spelling changes,
>    whitespace cleanups, etc).
> 
> (N/A)
> 
>  - It must follow the
>    :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
>    rules.
> 
> (Of course)
> 
>  - It or an equivalent fix must already exist in Linus' tree (upstream).
> 
> This last bullet is really the crux of what brings us to this point, if
> you're not willing to defend the vulnerabilities to maintain the
> interface in the mainline kernel, why should the upstream community
> maintain them in the stable kernels?
> 
> The question is not about who is using the interface, it's the fact that
> the resolution to the existing vulnerabilities is to remove the
> interface and nobody is making a case around the validity or
> exploit-ability of those vulnerabilities to carry along the interface
> in the interim.
> 
> If the revert does go into mainline, but were to skip stable, that only
> delays your re-merging burden briefly, while continuing to expose stable
> kernels to the vulnerabilities, and risks further users adopting an
> interface that no longer exists.  Thanks,

Thank you for your thoughtful response.  Rather than debate the degree of
of vulnerability, I propose an alternate solution.  The technical crux of
the matter is support for mediated devices.  So, let's exclude them when
these legacy interfaces are used, and allow them for native iommufd.  The
fix is small and simple: if there is no iommu capable domain in the container, 
then return false for the VFIO_UPDATE_VADDR extension. And to prevent locked_mm 
underflow, add to the new mm's locked_vm in VFIO_DMA_MAP_FLAG_VADDR.

Two small patches, which I can submit on monday, for 6.x and stable.

I can also submit a patch for iommufd to use these interfaces with no mdev
in vfio compat mode.

I am still committed to new interfaces for native iommufd, and am making good
progress with Jason's patch.

- Steve
