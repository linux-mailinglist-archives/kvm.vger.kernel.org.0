Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE45647508
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLHRja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHRj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:39:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF47DA6D
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:39:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8Fi1qs016465;
        Thu, 8 Dec 2022 17:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kumOS1lgpG4nK6/urLbCVRdbOlTiNFet6cjvcNDQw4A=;
 b=Yhjbe9s6qnBT54+MhG0m2gp8m7fd4VppviqGLS7+9mYy3/I3S1IZ5yLl7hpp2TFMwRER
 DjitO91klgtUi7mNUhAJBW07rFYXtW1su4taFErtjYG+LrHaAHkz0f6/dWZeFNEMr5gB
 kteqbDn7MJIVgH0CZKvj8m1C521bibKfgoWNhRWneUClviaCNwZIGqHYdUusHp4ZgJsf
 /BraVSua+mYHOTtAmZKYBdjhF08oHB8SvK15yMPKHXOiTU+tJtVgoBnRP653foKUu3Ea
 licNTgqnhUYvGPrKPW8505MhsiObUbpHyu5os0duRwoYxyf+wVFg3v9a3umE3NF6nWpp ZQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkbft1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 17:39:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8GmnrJ025388;
        Thu, 8 Dec 2022 17:39:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7yut05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 17:39:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSN7x4XrOAX0Xjs5s6QpQXdyimY+l10fIMoCSeL3ucisAe50NQA/6EIPYdLq3ZXmhbttheFXewoyk9FKRTF1deOKly+lw+AFYj/k6ZbsPEAq+cvGpoUltHkAcesh8NeNwc9jlolIzDQedHEBxWUHVjJ0tQqRqZ/gDmzn8KmXrnrkrHSe9874eyoD8Ct5gghQlvhXkppIebX/2F8wz7TbXIcDLlFPYKP2d/EPmxhBHzWQB0YeGwhlmK29MICJokj6LsE40/uDhitlsukcYEI+LlGCWq9ImEePrvLG2Kg1+y617Zh+pdCRqI6Z2gFXPtlnlTJcPXV0Q59fQMNMTsr3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kumOS1lgpG4nK6/urLbCVRdbOlTiNFet6cjvcNDQw4A=;
 b=a09bU0umYbElkxTtgHKKKwTey0YOyn382OR8VrLbatEFAgvNcisOfcTb1TjrS1c5eIT7MX0JcF9lQbeQd17zGjX1DRhnGfCTe1WCOHTs4HbRiuyTL4k2WvO2Nn94Wy7FbBwFJDVLE4AAWr3xVNv73nVzJRwUDR+6mJi6lQ822elA6HahHZx/wRSl1ICyy1bXY2nTX7aoiN9pBrwJPN+23qjy4fzDJVHPE+Eg8aupE7feUctSwowKazH6EJpUbQOow7w0G/IHtwCzF3QWKv+qMuh26/C0an9yXZq8k3cCJp3I2TiTrE1iVkfPy0vxa68OJjUeKcQrEyABp3n26XRdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kumOS1lgpG4nK6/urLbCVRdbOlTiNFet6cjvcNDQw4A=;
 b=MRJtd6bop37fqTUKUi3HD/faxqLUOuuBF4AcFuiveUtazIxYQhG/+dPbcz1KKAR81f+9ObMQnTpjlTmrRmb4at32CiUbYedwYydL/9coKhtWNe9oISMOa619nBsGsXPZtOH33Ib3zNJ5vKxrm4LiRiaA3p+Wvv6vf2zIN+Byq04=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 17:39:21 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 17:39:21 +0000
Message-ID: <542e7894-df8c-8e83-c6db-eeb22d9062fb@oracle.com>
Date:   Thu, 8 Dec 2022 12:39:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 7/8] vfio: change dma owner
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-8-git-send-email-steven.sistare@oracle.com>
 <Y5DGPcfxTJGk7IZm@ziepe.ca> <0f6d9adb-b5b9-ca52-9723-752c113e97c4@oracle.com>
 <Y5Ibvv9PNMifi0NF@ziepe.ca>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5Ibvv9PNMifi0NF@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::42) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 7023837f-fa25-4810-37db-08dad94323ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJStYP6vgPy0Mnkhk2Lg3KsxcPX/AAuajIlitZOi+Itzfww3EfFfmdzGIDNKu01VHcPG2pShgE99JaAOREn/4arg3alrh8jATvvnNZ+lLL0UXq76QttDCYe3JtTD9TJ5byS+lgvn+hVGmKNA395WqwsP/JcHlLZJ5ONf0sy9KuCEJj3LDm32hURbh9MVv3zbjcnLP1zsWyseQFuapLsE0ZxE3n4SZ58nP52LhjSjGPg5bp9QD/lPguV6FL8YKtYnJLivaugtd98hrX+yhG8FyDwONPp+d1wcAhuRryHpcwAgAYXtAdNvPc8smS2IOOz/Whyle/hymtz0GjFXthGF3V+XJAt5t2UrNOEiS4UsUr0B/aHuDIf12EGRqqpcOv7X0X7PQW1yoAVhQv0URgP6efjuniOkSl72UoDGQDB0CKDesM/da1734ztMumfpOkVWJaJyjgmc9qb+zPbQjYDJqIP1voqLkWvMrX8wMef/MS4b9R11vz/D2LOEh9oZhfhAOLotL0kIakAysLlSh8OI0AYa6CSChBXQctOUIPcnq0tolCuh0VMhKnAwfwfQ9aX5x51+3M8l+SkmMzzf61+NJqLZ45BboXA1nxTqT4Y5Ui5px3RukL3sf9zN34cniT47gtIe2ypegACj/tAY8NKSBh1hsJm6dgku4oiWAbXTkCR5UraiwjLEIJcY7/EFUwYb4MfIaXWE9+rbhxkbcQ8E3LR/9kudgaSfOVs5nCAOLwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(31686004)(83380400001)(6486002)(38100700002)(478600001)(36916002)(6506007)(36756003)(31696002)(86362001)(53546011)(2616005)(8676002)(44832011)(4326008)(6916009)(26005)(186003)(6512007)(66946007)(54906003)(2906002)(66556008)(41300700001)(8936002)(66476007)(316002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGV3d0tKVmR1UWpKalByYktoeFhIckp6eGlpOGgxNE92NVVSMEFuZSszOEQ4?=
 =?utf-8?B?YTU4TnMrRTNaeDlhVVk2bzZNNG8yRmFoNzF3OUI0Ym9jU1U3d1FRMzdpb1Jq?=
 =?utf-8?B?Ni9RV3N2R3ptcUFpZE5JWkJWNXVrMk1qSTBhRXhsa0E1OWNlbHpqUjI2UHdB?=
 =?utf-8?B?TXdEVitBbjJ3Tjl3Tzd0UFFxQW9iTTlmSE5QSE9XZ1RjalJMTGJYcHJ6OWJi?=
 =?utf-8?B?bHRKTmQ4WGdwWlg4UnlSUCt1ejBNNnQ4YVRwNEdUaG9jM2xmNnU2YW9oOTZU?=
 =?utf-8?B?M3ozUExQMjdZWmdnaU9QTjA3MENsNk43Um1rYi92WndiOXZCQ3ZHYkdsZmFt?=
 =?utf-8?B?eTR6N0pUa0l3UFg0RUpmNEt0SWRKNWFpZFJDMkpJTkJSQURLMWxsQ2p4YWN5?=
 =?utf-8?B?c0s0M1lrbTJmQ2hVQnAwa0Z4UjlVM3FBZmF5ZFBmc1lsMDhDZzhGbm9PRkor?=
 =?utf-8?B?dXFCMTd6TEc3czFzRTlHeUdqaUd0M25PalhqNWxuOGFwZHpyaWIwSURyMEFT?=
 =?utf-8?B?QWh2SVZYUHZoVGJIMDNNUjRqRTE4Z0tjWW5mbGI1Tjdqb3FhNDFVc1o2QkYy?=
 =?utf-8?B?UXdWajNBdVJjWUp1TkFDM016U29rK1pqRG9iLy9CWlZQcFJYaDE1WmNDMmxR?=
 =?utf-8?B?V2NMTWh4YVNlU25YQVBaK0hCd2VBbDIrd2RieFhpWU5rYjZZNFR2WjRybVNB?=
 =?utf-8?B?V290YTg2MlJyTjFMck5TbjU0aTJZN2c5a1B1ZXJKQXYrVnpRTUdQVS9uR2lr?=
 =?utf-8?B?Y25lZG1QSGRnemNUYVZRMFRJK3VaU3FNTm1CSjgrR3AxYnpVcUpmOWdzQ2ty?=
 =?utf-8?B?QjhHNTREamQrbzhnTWNRUHZBTXZ4VmZDbXJIa3oveDNGa093dEVwRnRJZGYw?=
 =?utf-8?B?L243a0xFWHRPV3lxM0ZNVUx6YkhWcmllRDhmMnBkakVhNVc1NlRGaitGL3FZ?=
 =?utf-8?B?NEFMbHBtUkpVaGF4aHVHMHQwb0JsZU5zTWZjWHVTQ2c0WUxySHVpVVh0cEFE?=
 =?utf-8?B?eXJCRXFOZTE4VVlSV01hamlPaUNhTmFaS09tcTVCSytjTjRiZWZ3ak5vNXVD?=
 =?utf-8?B?MS9qS1lHVzZHS2ZjdEtLcFpYdGgwcXdiVVNuV3pBajF1ZTZHTFpManhoc0xx?=
 =?utf-8?B?Vm1JUEJ6Z0tDMDdCOXMvdTRtdWd1emRpWTFsbDNKMWk1VG9ka1RhTkFqUnZD?=
 =?utf-8?B?TGZhaHZwTVpMRTNEY1NSN093UmJpaWhrcStCaS9BWkJwSWZpc0dOOFhXSnd0?=
 =?utf-8?B?bEpJelhWcHQyTDNTZzI0aGZZY0N5cThOaDdjR2kwMDRJRVdrMERzZGp0MGVZ?=
 =?utf-8?B?VkRjdFZFeUZjUkpLeEhpUWZ5aXI5M0tvMVZKdHZsRUhwelN4MytXUVZ2WGE3?=
 =?utf-8?B?NkdJUWxHZVY0QjlxM1YydllWS0U0THJYN2wvb3htVHRWbEo4Mks4OGptcHpn?=
 =?utf-8?B?MWVaWWt0TGdpUllvQy9idVd2d0tLV2VXMitCWkFRQzQyV2pwUHEyYUVTWGUr?=
 =?utf-8?B?SVJ0VFVMS2lxZ2FqdGtzWm5sMmhpSzVJdWpnTDIxOG9odHN0TjVYY0FiVGRn?=
 =?utf-8?B?WDRkU1JRRW1lYUZ4b0E1dnFZNEp3Skl3K0pkN2F2OXcrUEErbFpSV1l6enhx?=
 =?utf-8?B?YzB0aTB4RDhXSHVJMk1UNTJRTTlHdGlVUERTdWpEUHN6UHJrLzQrSCs5SVpD?=
 =?utf-8?B?U3dRSGgvbFRuMVU5dmhBSnNSZ3lla0VLN0VmR1dmU2w2cDJLVmI4OHUvbkxB?=
 =?utf-8?B?eTRsd3kxbFR5a0w4SmhTeFRwSUhiRTBwZUZHaE1JeG5PeWIvUTZlaUNJVGRD?=
 =?utf-8?B?US9naDlManNnZy8rL3VieDlsTUFUTWJLVW5KaDJ4TUd5YTY3VnpZQ2gxSGJ0?=
 =?utf-8?B?Q1grQ204K01hS2NoMHJNTVI2M2lyeXpPc2tqZ2ZYQko2cytUMjZuMFhweUxJ?=
 =?utf-8?B?YXBzUkNoVHdCdFZxU3RsYUpTVHN4WlpEc0RFRk93cm5nY0xOUDlodXFWa29S?=
 =?utf-8?B?SE9pbjV1WElFTDRlUUlDZDJSZmJnN2grREpGUzlKMmw5c3BmOUNqUWtDSHVl?=
 =?utf-8?B?S2pUci92VnNpS3FmNmRha2pKRVA5d0FLRmVIWEdvQnV0N1B3R05KK1NLZjFZ?=
 =?utf-8?B?QXlPVUJkZ3JTb3gvNXJDL0c3U2RPS00rN1VQZE15T1VtaW4xT1NDamhiR0ty?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7023837f-fa25-4810-37db-08dad94323ce
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 17:39:21.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdfJ4z27VmM2kWWdB+LlFrs4WOsPCoyd1ZbXbzCvLedBdv0CgJBHvzkmwApYhXgtcwEOo+mpMpN5pIVBiu18UqYWL10xZzCcTROqGq28KBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=897 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080148
X-Proofpoint-GUID: IUlqdp0MpBXij92eVxuWLgeZsmTaCcdS
X-Proofpoint-ORIG-GUID: IUlqdp0MpBXij92eVxuWLgeZsmTaCcdS
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/2022 12:15 PM, Jason Gunthorpe wrote:
> On Thu, Dec 08, 2022 at 11:48:08AM -0500, Steven Sistare wrote:
> 
>>> Anyhow, I came up with this thing. Needs a bit of polishing, the
>>> design is a bit odd for performance reasons, and I only compiled it.
>>
>> Thanks, I'll pull an iommfd development environment together and try it.
>> However, it will also need an interface to change vaddr for each dma region.
>> In general the vaddr will be different when the memory object is re-mapped 
>> after exec.
> 
> Ahh that is yuky :\
> 
> So I still like the one shot approach because it has nice error
> handling properties, and it lets us use the hacky very expensive "stop
> the world" lockng to avoid slowing the fast paths.
> 
> Passing in a sorted list of old_vaddr,new_vaddr is possibly fine, the
> kernel can bsearch it as it goes through all the pages objects.

Sorry, I was imprecise. I meant to say, "it will also need an interface to 
change all vaddrs".  Passing an array or list of new vaddrs in a one-shot
ioctl.

I hope the "very expensive path" is not horribly slow, as it is in the
critical path for guest pause time.  Right now the pause time is less than
100 millisecs.

- Steve

> Due to the way iommufd works, especially with copy, you end up with
> the 'pages' handle that holds the vaddr that many different IOVAs may
> refer to. So it is kind of weird to ask to change a single IOVA's
> mapping, it must always change all the mappings that have been copied
> that share vaddr, pin accounting and so forth.
> 
> This is another reason why I liked the one-shot global everything
> approach, as narrowing the objects to target cannot be done by IOVA -
> at best you could target a specific mm and vaddr range.
> 
> FWIW, there is a nice selftest in iommufd in
> tools/testing/selftests/iommu/iommufd.c and the way to develop
> something like this is to add a simple selftes to exercise your
> scenario and get everything sorted like that before going to qemu.
> 
> Using the vfio compat you can keep the existing qemu vfio type1 and
> just hack in a call the IOMMUFD ioctl in the right spot. No need to
> jump to the iommfd version of qemu for testing.
> 
> Jason
