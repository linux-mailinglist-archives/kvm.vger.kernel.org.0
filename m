Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4E4E7222
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355104AbiCYL1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 07:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238578AbiCYL1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 07:27:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDB270CFE
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 04:25:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P7WHgF010788;
        Fri, 25 Mar 2022 11:24:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jKlTTwhrD05StucjmQBrdRJbm7x/VgJkSTD2VparJps=;
 b=ZH1qYHQs2NtSoy3hevPG3rc5GwGN29QenpB7yC+toLTWVY3GstBs7y4wXML1xgcwbJ1Y
 WKuJzLbxIMANG4D/wIK6qlzPs1pRj70qltzzpN+duLLm/A2ZhWpOyOxlYzNCb5Ir1Bya
 zNCo/RzNjDqx05YL+XrigdOxdPuL7wjgwdl1I4tsv9uXuQDLh35CyjmCruhg0/gSMmJ2
 9pfR7LJSM55foMRIKHQYaW0fPMysev3ebJ7HKDXvst5Zv5pY1zxfEkptP3l1xw4etCrH
 b5TIlrC70vsrgX9VFd53AQBmSGWkgSkJ6LflkZ3OLwXIKSO+X8Sw1gGdtuj+gBdpKqx9 EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ssey8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 11:24:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22PBO0dB179732;
        Fri, 25 Mar 2022 11:24:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 3exawjgpfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 11:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOfkhtwXwDCZX0Igsft9PCHaXSfINyY1V21X+4xEQiH+GEltPcN6jOK8YrKr3hdNWYTHs6bzpwnPTfvHxWwMeBLQ37bTfKZKtjoWG8VhcZrUZ2XFkzzOWNXp380Lgy2Dhu8aQh9XFW5/QqmVg+ZSosuOHrqccAdJHsrrUMpH4o0xEosxOiVryqCgaDGPj/b66HRpUNXIzrH0AMLDFbSEUu6wcm0EJ4Jn0PGu6adDZAbVvmrDM11HZW3Z5q8DZmE68dPORJMDZYkUKRtxWgcJXRea6ViK3ywf/wMcAY/jEBP2Y6NsLebixVEOaGAEMBBDxceFW8WgugqFU9Hnq5bdxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKlTTwhrD05StucjmQBrdRJbm7x/VgJkSTD2VparJps=;
 b=aemhH/vgY8MUe/E41hh/UxP/qBNtHUeHj7aAOVcwKwZKeNBluR4gBoqCHew8pvi49dWn9GIGQh4TRZwoh6D0YBsIKfrPu7r7DkOqrXoC/MKIzs80UjcsdtIxWU0Nm+y2Gs56T7FL83sJYP/5rQdJBKOVzB1tzg+m0wLaex4NEuIWA9syJKOQwRe1XR8TVwtx+6ZYwBSGd4YYnBFxCRisSPRrtnWzKnbDP8E7Mvb+IV0VHNcFl00lTO/YoHe0Pmz1wfHFzPKyCHdxkGbq83r2phong2eUlNNAVI+7Q/jhR3SLGFVasBlpdCKtzpiWeSKKEgpqWEP/msX4/kzONxWwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKlTTwhrD05StucjmQBrdRJbm7x/VgJkSTD2VparJps=;
 b=M5UzGxP0gnnt1ZUbFwKFClrbEl4WusoESnksKg9XXpFml3eatWTFZY6vfAmY+8KryeXA3sabTfgXCTF5PYUyykcn59V1rygKQRKzgJfamO7W54sh4zhDDVjKNBmcbqIb601dJWmdSqVaiMt3emh/U1tTnTcdNRLVUzJWaQIgsKc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB3654.namprd10.prod.outlook.com (2603:10b6:a03:123::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 11:24:53 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::694b:b7c8:a322:febe]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::694b:b7c8:a322:febe%5]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 11:24:53 +0000
Message-ID: <a222ce0f-8be2-10e4-6856-7d58d45a3082@oracle.com>
Date:   Fri, 25 Mar 2022 11:24:40 +0000
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <20220324231159.GA11336@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220324231159.GA11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0252.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 624e037e-de48-4830-596a-08da0e521561
X-MS-TrafficTypeDiagnostic: BYAPR10MB3654:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3654F8D17A9D282491FCBB86BB1A9@BYAPR10MB3654.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWUaR30s/+/FCslo0/sdzq1G9prFrN3qKz/w+NLxjLnOKIc7fyfcayrWxNsaL2cL2vgk1QM+T7PEqBWDEl7f/ynhKlflgrli/3Hw4TaP78KzJSR0NJMyzkoHHQM0c74fz2VWpHlh3p3v2asy702P0XudfpUDmHizKvVjivNoIwotBjAK5DG9mmQovXNYV5iT5XWsx5Z6BnjWXBzsRUXfIRkJ2t3C2YvdgL5TPmvSC4BUBbKk7B2IUbEbAngz0I7vnxkS8/VwCgwAS4kkULa3D2TTJVqTOJ4BOL2a/8BRSwNB6hz4pkNU66wxfq4C+XA2ZXDLZ7Dlm5DxSFGi0itKd3/ACuvu0EnDxRSB3/R+e8qlS4om/cSQFTqDA8O10rEk3D0Swk8MdAbw45bNr0Xy8VzaiZnuMnY8EtjSC787FlBV+iedy4JJ5Iz7fL31Thq/0PS596FIgFYjQzrm4C0NEp8a0Y1HRouf29g+XixMBTpNJrj9NcRnc6WJz3FdD8rCv8Bxf9yFbVpebw9dtVWhI1Qwr1HMwJbb35CCJakAHw9RJWKCr3FitcqQ51s1vmbuvS1DDd950x8eu/4KeOhZZ61J95k9Pqkp3a4jyD3IaImTwJjIkBUy1CMNiZRHFF6hAle6l5KKwXBo7GtnyKnb54eg4Pw+8bSArlH7zh6jN70mPYyJ6RRP9U03q/n0zF6dbTdepbKdMYefUwyT9NX03g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(36756003)(54906003)(186003)(6506007)(316002)(6666004)(6512007)(2906002)(66476007)(2616005)(83380400001)(5660300002)(8676002)(4326008)(66556008)(66946007)(8936002)(7416002)(110136005)(26005)(38100700002)(53546011)(31696002)(86362001)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm15eTVoZHcvczlQckdlT1BGdFhxWk9WRDIvbnZKMkVaNlJuMWtFcWlOYkFt?=
 =?utf-8?B?eUVyM2Z1d2JCcWhQTEhLdUpUZ0xnZU9PTmF2OHJFYVg3dWp4Rmt2MFJUamlM?=
 =?utf-8?B?bEtZSXRtUkhETTJXKzhaOGNMc05kQXFZZlZYeFFFTlNPVE05MHFjYVU3ajFR?=
 =?utf-8?B?aVA1Q1NSbHEzK0dXTXk1QTVLMGZkRjB1VGhOWVlwV2FSczJKVGloT01lR2hu?=
 =?utf-8?B?NStyVzlrc1NiZTBqcm1mNzNVMVZRTnBvNUZmL2tMeUZLLzc1Si9NaDlISnlT?=
 =?utf-8?B?bXp5bjNYYWNiZDdOS3VyZVZpaXJOZU1tL2tnTUpFYVY1ZzFRalNyZjVvbFNr?=
 =?utf-8?B?LzY2UWFibnFOc2xudCtrKzlQZFJqTzcyTnUzR0l0N0UrRTFmRkZxeDRlWGFQ?=
 =?utf-8?B?WDBYdXhtMVAyUWlQeEhWNk1MRlUyMFplWVNYZXRnVmNtT2txZUlTQTEzVkFx?=
 =?utf-8?B?YWF0M0F6RldIbHFuZU1paVZGWFR2SHlUQjhYcnVCeFpJWUxhNkdOcDVtZHp2?=
 =?utf-8?B?VW43MjhNZ2hZU2VvWmh5YnVST1ZOOEc4UGJqUURvb0xscU1IL1NCT21WTXh0?=
 =?utf-8?B?M25uYWZaZzV0bklGL2xkTVM4WUJRQVpYY1Z6WjNXVVFHRGtqNjE1eDVENnJT?=
 =?utf-8?B?MlpxZ0dMeDNvR0srZFZ1QWFhN2kwUGFHY1pIQWVuV3YzRDhvbEl2QjZrcWsy?=
 =?utf-8?B?U1JxK0ZhQUhaVGdTdXllNDhUYkpBaFdiRkgyM0JsTThjWFVuRzcvbW5wVjUx?=
 =?utf-8?B?NldobmpJZzRpQUFJOGwrNHRTTkJyNFFWNWRPVUwwSWxSQy9kN3NRVDZYWXZ4?=
 =?utf-8?B?dldodERISkxqU3g5dFR2amJJMjh6VTFZazVyL1RmTWV2Yis5WGpvdnFMNkZr?=
 =?utf-8?B?U1cwS1B4TTR3VWhMWlRnQjNVUUVMV1FscnlCc21VUWZ6L2NGd3ZPay9OSVBB?=
 =?utf-8?B?T1BoWVNaVi80dm5LUDdjTG9CRXdqdlEzdkh0dFZJMXZvVG5INU5BQzM0WXpm?=
 =?utf-8?B?bXo1REJtMUI1TGZtTDUzQlByYVYraWpnUGdwbm9VQUtPSUM0STBZZ3RtTWVw?=
 =?utf-8?B?L05NTW1rOXhlaWsyclRuaGk1NUZEc1Y0aVkrV2hlWHZERkhtSkwvR2xvbWxm?=
 =?utf-8?B?RmRKek9YRHp2aWQwTkNLbGwrcDZvcHVueFVaRmZSckIyV3RORy9qM0tNS0tZ?=
 =?utf-8?B?UEkxWW1MdnNjdFhHbTNYcy9LSzVXTWtDcm95QnNGTjJRSFp6UEpIM0hHQkZW?=
 =?utf-8?B?RXJ3WUF2R1RyekprZXJXRnJCcmFoRjBqeGlHUXJpb001NzhwYU91UXdlWWlL?=
 =?utf-8?B?WGtWbHJtdHJsQlpXSlMwc2U1SnROcW1zdE5jM2d3c0RDYUpPZ20xQTA4bkVC?=
 =?utf-8?B?d214WFlxb3BJWDJtbWs3SkprS2pnQ200VzFrUEFINFJCMkREMzZjMU5oK1ln?=
 =?utf-8?B?dXhNTFdTc1NzTCtsYmRUYzExeUhJcnplYXpURFFiQ0pxb2hvV0RxelVadDZv?=
 =?utf-8?B?bi9FZGFmU05RWFAzSHdmNGsxZUhWSFdmRDQ5VW9pdEtNNHk5M1dEZWdTUThw?=
 =?utf-8?B?UGlpNzgyYWY4aTJoSCtlSEdHMVlha0U3NCtmTm10dFFrME95TU1hR25sU05x?=
 =?utf-8?B?TWF1RTFRQS8vWEVTaGxNM1RDUExjbE9SL2Y1NHlyRlo5ZXo5VmF2WmdncHhL?=
 =?utf-8?B?dTZBSTkwRnpXdlc0ZS9rMmZCRHRybWxYb1ZSbjltRnBMam5GbUE4T3E0WTZQ?=
 =?utf-8?B?M1pwTUY5T2s3UUtSU01ZRHFMK1FDSDNhVFk2UU5yakd6WnFNbTJKc2orS0V6?=
 =?utf-8?B?YnArS1Q5OE9NTEhMaGNtNzNlem8rMGQxcFVjdC8vaGtyT0RtNU9sbGJwTUlu?=
 =?utf-8?B?V3lCM0ZORlpYR0lSdGZmdm5qbVJyL0YxSEg2NUQrb1JKWjlIaHUxZWc0ckMr?=
 =?utf-8?B?U09uYk9KK0ZpelBZbUZIUWt0YjBaWldrdHpXSExuUlhPSkpGdkpyZGNnUXJ1?=
 =?utf-8?B?UmVDcGIyUUp3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624e037e-de48-4830-596a-08da0e521561
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 11:24:53.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4Goi3KCOamayP/xaHlgVsSwhoP022Gei7vmSNmrPoXtuDqIFvZG+svFgZscjro17tzGZzK9rXxliWKbL6J/RZ7ltezpMwHtEJT8J157T/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3654
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250064
X-Proofpoint-ORIG-GUID: mLJzLhq3-sCw5QtC3FLGPhvoXJrdn9jI
X-Proofpoint-GUID: mLJzLhq3-sCw5QtC3FLGPhvoXJrdn9jI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/22 23:11, Jason Gunthorpe wrote:
> On Thu, Mar 24, 2022 at 04:04:03PM -0600, Alex Williamson wrote:
>> On Wed, 23 Mar 2022 21:33:42 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:
>>> I don't think this is compatibility. No kernel today triggers qemu to
>>> use this feature as no kernel supports live migration. No existing
>>> qemu will trigger this feature with new kernels that support live
>>> migration v2. Therefore we can adjust qemu's dirty tracking at the
>>> same time we enable migration v2 in qemu.
>>
>> I guess I was assuming that enabling v2 migration in QEMU was dependent
>> on the existing type1 dirty tracking because it's the only means we
>> have to tell QEMU that all memory is perpetually dirty when we have a
>> DMA device.  Is that not correct?
> 
> I haven't looked closely at this part in qemu, but IMHO, if qemu sees
> that it has VFIO migration support but does not have any DMA dirty
> tracking capability it should not do precopy flows.
> 
> If there is a bug here we should certainly fix it before progressing
> the v2 patches. I'll ask Yishai & Co to take a look.

I think that's already the case.

wrt to VFIO IOMMU type1, kernel always exports a migration capability
and the page sizes it supports. In the VMM if it matches the page size
qemu is using (x86 it is PAGE_SIZE) it determines for Qemu it will /use/ vfio
container ioctls. Which well, I guess it's always if the syscall is
there considering we dirty every page.

In qemu, the start and stop of dirty tracking is actually unbounded (it attempts
to do it without checking if the capability is there), although
syncing the dirties from vfio against Qemu private tracking, it does check
if the dirty page tracking is supported prior to even trying the syncing via the
ioctl. /Most importantly/ prior to all of this, starting/stopping/syncing dirty
tracking, Qemu adds a live migration blocker if either the device doesn't support
migration or VFIO container doesn't support it (so migration won't even start).
So I think VMM knows how to deal with the lack of the dirty container ioctls as
far as my understanding goes.

TBH, I am not overly concerned with dirty page tracking in vfio-compat layer --
I have been doing both in tandem (old and new). We mainly need to decide what do
we wanna maintain in the compat layer. I can drop that IOMMU support code I have
from vfio-compat or we do the 'perpectual dirtying' that current does, or not
support the dirty ioctls in vfio-compat at all. Maybe the latter makes more sense,
as that might mimmic more accurately what hardware supports, and deprive VMMs from
even starting migration. The second looks useful for testing, but doing dirty of all
DMA-mapped memory seems to be too much in a real world migration scenario :(
specially as the guest size increases.
