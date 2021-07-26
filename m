Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0C3D54AA
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhGZHM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 03:12:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40960 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231725AbhGZHM0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 03:12:26 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16Q7p5q3015998;
        Mon, 26 Jul 2021 07:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=wMZSOi9gTCuFYqLPV9VUocIJwyCKP9cWpGU1Nft0wXo=;
 b=RGa41IJ0g3iBTSw4LVzmKfjYca92+d7WVjarbLqqT+WfFIPfZNnpkLyAweKGHRohmNJ8
 urJjEsMniNb/4dVS2fzpBVlq8q25G6aWVbuoteWXfORq7FNY3MjVgkYkRxLWAzT4anET
 ml7UIHcVfAR7qQxuN1c5548/MluGpJm+VMXZK2nINiq+xa5gnbASupP6DKLl14qEKnYZ
 qrcFNzqCFk+x3mwIAJZBGqhyQCJy9KhbR/eXHyONPN7KDfjF5V6za7tk01CJe+Zq+sCP
 6MKBiumkhlk44kg4x1+VwekizVUrcDAdhll7lDZSgywWEPyewSl3zjSkmmpgM2N1kwim 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=wMZSOi9gTCuFYqLPV9VUocIJwyCKP9cWpGU1Nft0wXo=;
 b=YGyFjEWbrZjm9nZ6l6ZtIj0Vv7o7FVpxBuPxzZ9/rxbAQNCZ8wYuOYHQaB1DJd6+C8C+
 DfJES7cznObFgTH3RFbvb78NL0uOIX1j8SDosuWE6TCyri+opUijEYXIEh4ixmSTZUpd
 JGm9ofgFTXTnfBXfVtgQyPfxtFEODeHUNhVbAhLpIT73EBnZtS1M5qmvrcn4ARYj7ryZ
 GHIQf9Qm3uz7FI9jJz2xCNLAM+wg7pgThOuSqg/fi6o9tn5zVUuruClb0AxnPpRWIiq0
 JanU4UZD6LEuIM01V1jaElFKfINvuZSdO631GtcW3zGOKlG71wFVqc/MthMDphcrL53R nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a0bdrtcxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 07:52:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16Q7or35086062;
        Mon, 26 Jul 2021 07:52:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 3a07yuwabs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 07:52:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5TSD7Q5p6fnk/cDqNeZk21JPVYB+XRKoKfxO1h8/6eoV8UO30mh6FJEXLlpfJfWfn/jxt26r3sEpzislJF5xHnWJts8mu9IACuF6bZHe6io33DW+IkCJ8p9ZoZsKf3yWWwEMmtBQRm5HnWY/0NtAxWuwdPSg+YaOjpxMrdJz3l/4oP+Jhzh9bRdVuR2BlRj5KRRhKrpeYTXYDHDRbCK50ez8CFWaDVj+36KgynMWHTNCgWb/SoFh2VKj4wMxf9eyAd6FUVItY/4K9zBmljJKNRvFY/TozOhrG4Wtp8MOr5utpA6qQ+VKnyz/HkPYJGO/Odvy79PwYpNjqgRu3gzNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMZSOi9gTCuFYqLPV9VUocIJwyCKP9cWpGU1Nft0wXo=;
 b=gcUFIZ1MO6OVDiOALyspVNPo4/CqsV7YbWV2mHtR0HWfRgQeMHZWczYGaPsUW24Wl0f5GcdIG9iv2UQJ7Cbx+UDo26IH1VurK6wO3TveReNDp8PnSEXKgqNnGJu7x/v7s3Rzbu0O/5qwK30DW1UFAOWrNgsIojwvms+5eE0+KQ14MbfKZzffe3qNlCTe/310ujNFhG5VcUIq3TZR3e6jmERBifRZbdtlpccM96vzY6Nzf+yZ1Kw3GzBS3qZD0Pbgc76G6Gs+VokSePCQEC8fksUuSR7wDsVh/l8ZUpr/AQXA/eBUKUlkgQdZtSNQ/x+yn7OKM/1zj1xh0MqmiDrhwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMZSOi9gTCuFYqLPV9VUocIJwyCKP9cWpGU1Nft0wXo=;
 b=CFIu4za+4oJEAMjkHXJhzO+isANDUuPujj5pMJETWH+vjauBeL4X2KrWXlOrGls7EQY7T462u/W6aJG3kb86lmGTKjhZVCon01XXOYwh6F0DmTrer8oJVwXi6228rTlwIJfUo59JQ9gsfr8TqFf073oVypSichBhSl45ff4AIQY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1246.namprd10.prod.outlook.com
 (2603:10b6:301:5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 07:52:48 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 07:52:48 +0000
Date:   Mon, 26 Jul 2021 10:52:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     bgardon@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86/mmu: Use an rwlock for the x86 MMU
Message-ID: <20210726075238.GA10030@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Mon, 26 Jul 2021 07:52:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d908981-02d9-4a01-d1b3-08d9500a5c56
X-MS-TrafficTypeDiagnostic: MWHPR10MB1246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB12460B514FE1699B5E8D92498EE89@MWHPR10MB1246.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qaU5X6YAvELSJyvyhBB1gXE/UDpxFeXwFacX1+x6h9+7ZITJswROG11IupvoT3nJaZq0BazjUncDvUGzHEtozwKRjAFiwyfwIpcgwTHcwJxjDeIhYO4iJleh3FDYLgqkpAsylPv4ISo5OKaAWAdMy6t5cUHoEJdMqwDrM//W+FpScCATszpLE3PFR7sqQoVkBqjLJDQpGIrvnA9Y1eSUp8tvs4b1aGTAIG1G7T8FRx4SIj1e1IhZQYNBOXrLAdjH7WemZBo10PP5osj6DU2Be5YZPmTtkh2B5aLCy6Qb44aesQYU6xkMI1io0py6oD5xkknZ1jIYfyFylGvHtNXmC8kyDXDoz0JfSnJOMjXGda6GlgqxDtQlVjw9Sy4H+ISsHdPXd3Wvj3QuvTFYp4ejj/MkgrWx7ojEK6TmCgU8Pa/DV4GdHX5wzNps5VkSIbWnHtvbhb5b5XS6zKdSBe0fVVVHrxHIXTKiTi2BdxlxgFpD0cFr+ZP5NmUEaGIWO24VurzDdCBs5S8D22fL8Hv5Ci7t8S/gHP70nQZGWDhWh6k+/ttcT8u33w1i+8BMlxtwbcSZqt2ldTlvPc+nDQZvs7zTlbAQrUkZmeGspLAGjZiL5b+fZnVqMcugkT1EWIRKmOthr8kyFR4xK0htFc+UXiTDNGVSuLZ/z0f9/vR+96aZYiNM6Ja+kr/+DulbIOcwoglQy+2TVtYytUbDUeKmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(6666004)(38100700002)(5660300002)(186003)(83380400001)(44832011)(33716001)(4326008)(33656002)(66556008)(66476007)(38350700002)(956004)(6916009)(86362001)(66946007)(316002)(8936002)(1076003)(55016002)(9686003)(2906002)(52116002)(6496006)(478600001)(26005)(9576002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJAhvBj3D1YzBaAwaLhkrdDKt6tU97QJbFgQSWzUkbYTrXuooMhoImsN+TSr?=
 =?us-ascii?Q?D244yvP2v1vGMdxeL2Uru3N3gdXHGeH52xEdtErW95m6SLQ8WEcMjJAfTnMt?=
 =?us-ascii?Q?uynybCB3ToPaSe8r8qz1KEK114L+op86/uAOwzcjIGIqBVcIhWDHo4Qm8lLw?=
 =?us-ascii?Q?4F1119Wnk5hs0p0MGKq3UBNpO6+q3oMkumwwTu3C+D44+yAQuvx2BJi7dJg7?=
 =?us-ascii?Q?//lkNc0nG7FoNXYAKGKe5Yb+25cN1xCMm1Ts5sQMZ0RGPHz0ojUd1Bd1c4NT?=
 =?us-ascii?Q?7VMvpWQ9vSn7rF00gvT/oFNuQm+NTWU2fZJp+nkeeV6wBgyEWKPg9WchQ5gV?=
 =?us-ascii?Q?s6zpFgFkpkHDph0tKyUtbPetTJ1u7YlaEPqwwXKEZ9hBcIM9lxDcIt98MVam?=
 =?us-ascii?Q?F9u5Z0N98Sel/v7Cp+uenZb+EWjdWY/lsIMjN8b509wouePUzU4Kp//tem9o?=
 =?us-ascii?Q?jrY5e77idKxjcO/+d7yYjZwgWX0hy3fQJJ6b/ktWDPGLstm/y904oJgdSjfq?=
 =?us-ascii?Q?bICRK+bhcqGiMIV32vJ/Zqv+aY2dyh80s/ORUnkKOMrb4yXmeW5tSwivpvyD?=
 =?us-ascii?Q?Ji0NBgue+4ieMmFWvtgnk0OoDypdV1y2GpZ9jSe7KUI1lWOljTc60E513CBR?=
 =?us-ascii?Q?X7mgnKes9Gp5QtasFjatwOyGMegM+C3Wn7yMBV97XakeoOhj+srLzE75YsLj?=
 =?us-ascii?Q?8H0NJGd03ezOi2T9gr2pTCj3OuQrMPZ+vqzYfxPDLICsmfEXsXfk+t8uJuxS?=
 =?us-ascii?Q?Nk/rrseBZ+CtaxygWvSTtjx/J1S1L3W6A+nr1Dn8QzS/rRwmdFCmJzmT+MW8?=
 =?us-ascii?Q?rg8L8jyUxroFEFXK9Fsb4sluAcZd11U6qWrRyBWoovh5sO9/tlBtUlP9k/Hg?=
 =?us-ascii?Q?IVSSDaB4TQ4hljsrH+gVS9vUCPBiVKSINjs4QhmWn7Wx6uP+ljBEbK4QCQY6?=
 =?us-ascii?Q?Y2Dz91To8YTAGNRIKhaZIhsNqvJFgEPYojZYYD8eBi2xLW77+kIqtq7Ugkud?=
 =?us-ascii?Q?j7+woccBu/IjrdUVHX/3ZqKP77ntKflBLWt3X68wqwlhSYrHqmaQ3PSD0g2W?=
 =?us-ascii?Q?jfhEi4zxEDuLPY7hcKl7YhAMdmFe/IYW+NatFO35dTjur5PCjOmHDuYdhXGN?=
 =?us-ascii?Q?B+U8bhe5sNVR7TGGechLg5KhuQ+iPyhGsp2haDut/cxosZiSJ1CeWAgu6q30?=
 =?us-ascii?Q?cq+aBaRYED7BEuQjKymeNTBo8yprA8VyK91WA40cQDs/KbYRn45cbD4RdK7z?=
 =?us-ascii?Q?kjWaI9K9WHuABeXOUCHE3BydoX5VtrOGcyT1a+Qe2GiJXeHqihPtjaE/Xc11?=
 =?us-ascii?Q?UwoLXW2t3D9g/IE3ESJm/Psi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d908981-02d9-4a01-d1b3-08d9500a5c56
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 07:52:47.9644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rO1JrvVBTetvdIe8RTjwHLpf5VZDgtYR0/bxaGiegJH5IVV4er5F7ZzrzxW6m3Sgx5em/S4abbldgGz6I9KPkNjvMLdzEG+oaX7PEUYIKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1246
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10056 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=839 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260046
X-Proofpoint-GUID: fXpgIa0SP_3qwOm3VEsUtBm8mswKQMYX
X-Proofpoint-ORIG-GUID: fXpgIa0SP_3qwOm3VEsUtBm8mswKQMYX
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ This is not the correct patch to blame, but there is something going
  on here which I don't understand so this email is more about me
  learning rather than reporting bugs. - dan ]

Hello Ben Gardon,

The patch 531810caa9f4: "KVM: x86/mmu: Use an rwlock for the x86 MMU"
from Feb 2, 2021, leads to the following static checker warning:

	arch/x86/kvm/mmu/mmu.c:5769 kvm_mmu_zap_all()
	warn: sleeping in atomic context

arch/x86/kvm/mmu/mmu.c
    5756 void kvm_mmu_zap_all(struct kvm *kvm)
    5757 {
    5758 	struct kvm_mmu_page *sp, *node;
    5759 	LIST_HEAD(invalid_list);
    5760 	int ign;
    5761 
    5762 	write_lock(&kvm->mmu_lock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^
This line bumps the preempt count.

    5763 restart:
    5764 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
    5765 		if (WARN_ON(sp->role.invalid))
    5766 			continue;
    5767 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
    5768 			goto restart;
--> 5769 		if (cond_resched_rwlock_write(&kvm->mmu_lock))
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This line triggers a sleeping in atomic warning.  What's going on here
that I'm not understanding?

    5770 			goto restart;
    5771 	}
    5772 
    5773 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
    5774 
    5775 	if (is_tdp_mmu_enabled(kvm))
    5776 		kvm_tdp_mmu_zap_all(kvm);
    5777 
    5778 	write_unlock(&kvm->mmu_lock);
    5779 }

regards,
dan carpenter
