Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848BB64E3B6
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 23:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLOWPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 17:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLOWPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 17:15:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4761823EBA
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 14:15:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3ux7026525;
        Thu, 15 Dec 2022 22:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JS4/hiS1CsaNshWCUErUCA7T8oKzJjCmm1jvwrS411Y=;
 b=RLh2+jiktF4b5IHdIvPZmBwmotbTDWvkldReHgTe8UQdWsWcA44w+dsszxhmv5hpppV3
 BvPA4l0t50kP9VXAc+lgUcwwFGMXaX3K+KAmL40xqFj4GYdq1/ieQzHtrCms83N8bJ/c
 FhQS+hbow3SuNElHywxZDTbeBhRS+qZNeBbPHNOhf2LeaYu/cJyfjev773xuTOWLLj/U
 legiPA8p28GYMOsGqA0L4AeWVTVZ6WNmAlq3wcC6NDbBmILvEquJfIRgU+KgieHIISXo
 lUXnlZoj+CAk+h19UL1yPsPQsMxvFWaEbDBhacKUV2RUY8W7ughbyQwzL8VW4vQYCIEx jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerxc8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 22:15:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKs4Fe028864;
        Thu, 15 Dec 2022 22:15:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeyfrea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 22:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/2aUiuKruO0hOaAb1hCjk1xD53O5Vqbcpw7ye+9UrZa9GLRoSHljT59BrzQzPqz1AQEmVBDwH02zkZiIsMh1tTFXsT8oVxLoSP9VuqOieqBTV89e2e9ne8QdLyKmayBMerSbLHrtUhVV+16+YaREMiT6eGFsmfnCY011L9g2ztdflQDTu3eD9+INk9452wF6HH0N+Avccjaqb6dDc2U6LX4epXftycODn2Y2QRWyRSHPc3srvpyqr6x/SW+QMZvHgjdYUleGvA2GCwHo3Yzp5IHbJZZulaUQ4STsTFXJLPUfv8fjkVXzFL4/QIcTXn3fhcPgWrKVhdoU/QGLqM70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS4/hiS1CsaNshWCUErUCA7T8oKzJjCmm1jvwrS411Y=;
 b=AyYtYqGVrrrKn0YL06Zv8kt1C/BZZQCGJ5HqBWNqwKW1bKNUztlrtV2eoyLm0zRkI9BpvcdOGiNLoC0vXcKn3ecFmYJHGRDjBMFyrVNARv5BpV/LMZzCMNJC9EW5Nlfv63NNlmv939f40qHk1OpQvhZ/LkiePHD40d+q68/YakQJrwwb/YSiLyYZq82pbtQ9LdmJKGbOnisTYLY/unTpwMJrXx6FDTEFskhm29Z8xAbA3P8/iNuYOT/LqJZrmaYPPwEW6n0oND6AHHICqoKx63UX3m2RhoBkAKeJ1MVksiArOaABiYHczjZaldu/MFUiRdH0UV50AoXh24weOTv/iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS4/hiS1CsaNshWCUErUCA7T8oKzJjCmm1jvwrS411Y=;
 b=ceuLXxh+5RMEvw0bJ07i6ewTBxr20iGo0/lGnc/OGIYJGhIWWZcyKTbKkGkjb4q1lLgzsdF2nLDs9ahW4pAfVo/y24v89RR4NcruENrvBGUCJezRbkHBDcP2y5qgmFeWKX8Ck/aV7/EreaTfN/ZJJbvA3pdHwWQMrR1fWb+RoU4=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by MW4PR10MB6583.namprd10.prod.outlook.com (2603:10b6:303:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 22:15:05 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 22:15:05 +0000
Message-ID: <05aab129-7ac1-989b-9bb5-014023deba2f@oracle.com>
Date:   Thu, 15 Dec 2022 17:15:02 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V5 3/7] vfio/type1: count reserved pages
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-4-git-send-email-steven.sistare@oracle.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1671141424-81853-4-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:208:23c::9) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|MW4PR10MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: eec406c7-7904-4a80-5ed2-08dadee9d196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5C7Cn4oVWmm6FkC0rtp93SsvRdXOXnzyScfAbhP+375FL4/Akb96tiM+4kaMQECDWllrlPpGfIwVxszz/hq0IAfm4aqvutHQif18Xp8ZL3a9VpUW7Ap84ikEB5E7sSlH70S2iBN0lrNfdMBlOxp7Mu3DTpikP6QzsTb21NHQ6JRSMhU788kKzy6vrcHfgGL+d1W3iX9onMXOlbRq1dZiIuTJxTd5LgJ3W4sD454gyDe/L/yl5pZXWsN2oCFJBl4UnLEPSSgWI3hTsp/HfA8d6TKfMRYsM16uulTwcbTC40mNH8sXMSJevUGHGPdWkysXNEpapucqyv9Nd9zxcSVwwPnkhRFF8wou47Zvr8w1o3JMs2fP+gfR5mYipoYRXhwAxd3jJKrai/1x5BF7UzbDLafENLy/fGYojD20EldQEl+6besJtudf+i89MwAVmE1Hj4k/xj3lGd+rUjLpg5Kg/Ywsdzt8lMQYJ7VGLXFbAz49D5JihNJUyQkmvg2SJo1D3RbjKTcp734ZIrrGCkW97TCKbyuwQhKrz3SuvAjxCeQIzNCDBZ+CH3pOHwwGZ/RBn+fDo8Moz+kn/A9ava2WpxgKb43KSQ5YawFHJYf9PeqZ/yvQ7lq7WjlhvADWaFmy6CbenC9RrlnmBxcZlODi4PslSmfnTCwkrjtklv2EfOdARIzEtIWDwjEAFEWShKNL12Lg45dy1Wefz8EuPgsDQDItQUCCS5mj/v5T4T/0Xs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199015)(2906002)(66476007)(5660300002)(66946007)(4326008)(41300700001)(8936002)(66556008)(316002)(6916009)(54906003)(8676002)(26005)(6506007)(53546011)(36756003)(186003)(83380400001)(6666004)(6512007)(478600001)(36916002)(2616005)(6486002)(38100700002)(44832011)(31686004)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blVQR0hJbzN0d3lLK3JaNTlLcUpwRGpBajY0V3gwUUphVTdZWnUrQUJWVmJm?=
 =?utf-8?B?dXRoRyt0dWxHbkRJVC9xb2RDSFIvTWkrODg0Z1B3WmlDSVBITnU1VEhmTEhZ?=
 =?utf-8?B?aGZtUTBHK0MwZytnQlFTeDhCOFFLTGNSb0ZxUHpCR1ZYWTFreTNJU2FqZXdJ?=
 =?utf-8?B?R0VyOU9aZXZlcWdLLzhleFRscUZGRFlVL0JRVWtOaC85V1pBUkozdXZOcTdy?=
 =?utf-8?B?OG53ZmxqdmQwTGxqQjViQnJ6TWxyK21ldkJyM3hNMXd4bC92Wkh4SmJjY3FL?=
 =?utf-8?B?cU1FMjlUZGpVUHdYTWNIc1ByTjVZbGg2dkVmVnNvOXNqYmU4VTNablNvU1Bn?=
 =?utf-8?B?VkZqaXN3bDlJa2l4QkZTL3pQVmdNZnV6Wlhqc0RLUENyWTR1Uy9lNmdlbXRV?=
 =?utf-8?B?VTZFMWxzMFZ1a0dZWE1BUHlTU0lvTkN3a1U2MnV6QjNkYnI0eklsQ1pjMk91?=
 =?utf-8?B?WnNndHZxTDBLNU1zYVNzdytYWm12N01DNHQzNlpIUHlJVkZTQ2w0NFF6aG5w?=
 =?utf-8?B?UjRoY29tRE5iQ2xKNURqOWROelJOMjlsZkN2N3BFTVFiU3VPRnBEeVpxaW02?=
 =?utf-8?B?aWNKRlY5ek9IY3p6cU1sbjhYUzdpKzZ1MjhXOEQyVEJPc3FMcE5mNE1wVkdE?=
 =?utf-8?B?NGtVMTBKbHNhSUZIaUFRWVFXc2pkbCtjSGk1RDJlSTFsYWFyNjdZeStVdjB5?=
 =?utf-8?B?eW15SDZmZG1xOEdmN0JEMUFHaVltNGUzc3VvUThPM0lMeEs4RjNQRHcydDZJ?=
 =?utf-8?B?V0tXd05NeEFxcUw4d2wrcDFEUStkcS9YQ2xZS0NuRTRRaDRORTI4VnI4Z3p0?=
 =?utf-8?B?M3FlK2ZiR2h1a0ZRVXR2amwrZm1xbms4ZjdiQXdmRUlLd092ZEEvWG5rMmRI?=
 =?utf-8?B?QkRUWFFldkJjUUFwWkwyLzhOTzZiL1h1ZzltalVnMEdId2ladTdyWEovVG00?=
 =?utf-8?B?ZENNN0JFUEtYNDJNVHVwRzN2ZGJqWVJiYmZ4bFpnUGRCMFR2dDFGbGgwSkJr?=
 =?utf-8?B?ZXh0MGMyNE0yVGI5bm9UaThGL0J2U3U3L2I1V3dFRjVuSi9VVWxHQzVpMGhE?=
 =?utf-8?B?QWNvcmQvNjZ1Yk9qMmhaOXkyUyt4U2kzRkwrQklha2dpdWg3RE5LNWZiNzlJ?=
 =?utf-8?B?T1RFeitLajVaR1VIWGRvSG9tTDUxVG0rb2lnYWN3VjVZTFdSTWpBaTlpOVBr?=
 =?utf-8?B?WlM2MitMR1Uxc1BvQ3liMi9rcFBOclV1Vzk3SzZqbkNSOWkzbkVEaGNlWXhN?=
 =?utf-8?B?Tk9oSVpXZ3Yzd1Y4S0oxeVdSZWE1bnpSbDZNVmxKOFRHa0F2d084OWZBTUZK?=
 =?utf-8?B?WW9xL2Y1NEtkVU5qaWg0Vi8xdFVocElsS1piVmltTGUrT25xTlVsd0hkM0Y2?=
 =?utf-8?B?Q2V0ZTJKRCtQQmdLanljUWI0OStJQkNWSElCMU82TWZTRjZ5eWEwR2ZKVXRq?=
 =?utf-8?B?WlVBWVh4OFluVkxCeGtCRDFCRFhFRWpxNVN5NHhWSUh0Q21VbUpVc01YODI4?=
 =?utf-8?B?aGdrdFloang0M2JLcHp3aWFHZzdnV0Y5MDFQNWs5S28xTGJlbEpyOUtyVDk0?=
 =?utf-8?B?Ukh2TGM2TjlpK1h6TlRRYXVnU2JtV2RFa2V3eThrR3BRY3Y3ejFPNERtUTVp?=
 =?utf-8?B?bHlrSEQrdS9BUVZpbU9QZmIyNTdoTlc1Rm1YREdMckxGRDFraVRTYWZ1VTc4?=
 =?utf-8?B?bzQ3UWt3bVUwTVV2cm1lWXl4bHE5NTVkYTMvR0p6cGhVWEIyM3FzbS8zdVNq?=
 =?utf-8?B?WWV0bHE4NFd1dnJuQ3FtVnFlTGMyYW1pWWlCd1dwMGIwSkEyQ1l6SlZDaXpl?=
 =?utf-8?B?UmZuYjFuTXNkcjloekE2TGRvUVVldEFYTHpHS0oxSEVyMFZicW9qanJQZnVB?=
 =?utf-8?B?d1hDK2gza3g2Qm55MXFKME9CNm4wU3BtcHZKWHRrRGR1N2JHOXlSVXcyaHhB?=
 =?utf-8?B?U1Z5SW9kSTlZd0pLNVVSZjhpbGk4ZHRjeWdDZ0RQbEpVamRLVkViczJJajJ2?=
 =?utf-8?B?ODY0eWVVTmVsY0dORFRWaHU0VTBIczBCdDVuSVhtcE1HUmtRRlltc0NKb1BY?=
 =?utf-8?B?ZHk1YnhRMElYMWF6OWxudDRPZXRPL2RsN1lWKytRV2lHWjNqUVR5aFBNWUtr?=
 =?utf-8?B?ckIxVmc1OUkvejVpY2M2bnZMWDJvQmFqdk41Sk5VZndtK0psby9RYXUvRDZ6?=
 =?utf-8?B?YlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec406c7-7904-4a80-5ed2-08dadee9d196
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 22:15:05.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPVzXqe/Kswozm5pbUbUtw9HZshUY0L4lRxJZR5qMxZYZPY/7D84rtACZIpAnIduzbYk1TTrVQJA04K2IKGkVaYlqIbdHHM/0aeCSGwpsWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150184
X-Proofpoint-ORIG-GUID: 4PhaFRR-4aSt5mohYI5rq9x0j7a4iaPB
X-Proofpoint-GUID: 4PhaFRR-4aSt5mohYI5rq9x0j7a4iaPB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I just realized it makes more sense to directly count dma->locked_vm, which
can be done with a few lines in vfio_lock_acct.  I will do that tomorrow,
along with addressing any new comments from this review.

- Steve

On 12/15/2022 4:57 PM, Steve Sistare wrote:
> A pinned dma mapping may include reserved pages, which are not included
> in the task's locked_vm count.  Maintain a count of reserved pages, for
> iommu capable devices, so that locked_vm can be restored after fork or
> exec in a subsequent patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index cd49b656..add87cd 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -101,6 +101,7 @@ struct vfio_dma {
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
>  	struct mm_struct	*mm;
> +	long			reserved_pages;
>  };
>  
>  struct vfio_batch {
> @@ -662,7 +663,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  {
>  	unsigned long pfn;
>  	struct mm_struct *mm = current->mm;
> -	long ret, pinned = 0, lock_acct = 0;
> +	long ret, pinned = 0, lock_acct = 0, reserved_pages = 0;
>  	bool rsvd;
>  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
>  
> @@ -716,7 +717,9 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (rsvd) {
> +				reserved_pages++;
> +			} else if (!vfio_find_vpfn(dma, iova)) {
>  				if (!dma->lock_cap &&
>  				    mm->locked_vm + lock_acct + 1 > limit) {
>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> @@ -746,6 +749,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  
>  out:
>  	ret = vfio_lock_acct(dma, lock_acct, false);
> +	if (!ret)
> +		dma->reserved_pages += reserved_pages;
>  
>  unpin_out:
>  	if (batch->size == 1 && !batch->offset) {
> @@ -771,7 +776,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    unsigned long pfn, long npage,
>  				    bool do_accounting)
>  {
> -	long unlocked = 0, locked = 0;
> +	long unlocked = 0, locked = 0, reserved_pages = 0;
>  	long i;
>  
>  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> @@ -779,9 +784,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  			unlocked++;
>  			if (vfio_find_vpfn(dma, iova))
>  				locked++;
> +		} else {
> +			reserved_pages++;
>  		}
>  	}
>  
> +	dma->reserved_pages -= reserved_pages;
>  	if (do_accounting)
>  		vfio_lock_acct(dma, locked - unlocked, true);
>  
