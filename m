Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC88344F61
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhCVS65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:58:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhCVS6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:58:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MInRxd020336;
        Mon, 22 Mar 2021 18:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xJx38k7Yfwxuwb8DcYyX9exNs9Z2W5O7BFVCGJFGOcA=;
 b=FfXQes+Okdexgc21ZgkiwymHs3/QQbGgGPAtr5zc4FoSKKalmojxcbICPkolnFTNLf9B
 ow6+fhxS71CGpC72yQi1EkKsRdGLzPqQSETwHtpKdVov6WRtTCCmOqB+y+C8GdQr/ttE
 TW3lXMvImI6wfeuAq9IbqUTVuauXtOp6yRynw0F/Dpwm6E5XwbhvxMXmJjXUjqlFdsWv
 p15hVzHzA+jh6g18r9k6gFAE2M8T8YEERryuOLTFz/NJdpJbIYI6xEMdjIwiAPV3kZwH
 czDrdfm18sj0w+rEbjFs69Ubn2qjouuimuyS4aEne9rcdCUMxvOwlypch2O7Imo8h8US yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mch49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIo8Iq135034;
        Mon, 22 Mar 2021 18:58:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 37dttqxyc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqW99gLdEDqH6cDpWteuzPDB5W2CW5J13IjXMDHxlwq7m2YMmsB6sZpUDcJ94HifkuwmVhvbaVApkEuM7lIoqqfMTog/gbxkvF+RkjcHODVHpuMGMV17hx8BgFEi0HtDC8RnKYsTAZJgUhlGrmiOy3YoZ/W19sgh2omlz5zGJb+54YkGwCL4H1Sb5kLP3lvwH1Obn4Gmg34tXFCvxatYQFa+mzA8pYWaYgvlBKQhoLnKNvfj6fUiCItQwGQ4FffJtTtYtBDxMX+xEwxX8eghrvuRg/39qLknjECIjduyEWaITvoMlbzskzJBM+1ooHF9L5uRt63xiUKh5CdmopQ5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJx38k7Yfwxuwb8DcYyX9exNs9Z2W5O7BFVCGJFGOcA=;
 b=G38I/kiD/PExcpIX9+pQkT1LefxQgq62m8qhnkEJAmPBh4+AMOEdFwF6MphAPVpKzQcUi6Xt/6Ma3vT0056BF1LzA3BQL55uU6HuNVbNVyx0JrHVT04QPb9Yl+uOOkmWb0m0lTYAkz6edxRm1MK0mdTCI/YTG4g0ENHHGAzlLly7rNwh/XeBvAdNSgmWASwBA55pV14DuRvLH6RFtKGh0OB+nojUiaV+LUvZxTpqH3ikeINEkf0Y8tyLX9HszXr6GlFGKGPiLGFiKFSrPKAogDgAeK+t+aLRA+UTqVZZnOd6VCHDSUtMo+vM2dSm9FPw8IF3k+drBX6kxh6yE9vNOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJx38k7Yfwxuwb8DcYyX9exNs9Z2W5O7BFVCGJFGOcA=;
 b=rSJLjdkHgipbO8geaYOc32v2iB5Vol19VPndGjS4ZxgurLyR7xgBB7P5JWJnVlYtTdVRlquB3n2bRIUix0fSG24NGITUC1jqS9ZwNArk6etqKI9Z+oTIWmz80BtSGkD2mzpmqlW/scE+pUxd4Tg9pmTxRYsXUWhHsc/L76UPmvs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:58:40 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 18:58:40 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/4 v4] nSVM: Test host RFLAGS.TF on VMRUN
Date:   Mon, 22 Mar 2021 14:10:03 -0400
Message-Id: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 18:58:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6a3fede-6b26-4dc2-dcf8-08d8ed6481ac
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795040A03C95BD7A65ED60581659@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIKlRFJFcrcgFhptEEJlEiv/Ki+oWVlFEcS+frAER2PU3UaZSYtWhogmcl2OSdWs7tKmebEXeCY7WYe8XWz9+ALgW+dSno5aGh4zYYKbSO+91Z1UPckpFT1hsCKHyQo6Z2NEDz6yq2GhzTX4Jat29WHrreoILlcHlQW+7QViAGHf9dNE9c7RbnBTuImT8BCPkWBbl/M9cnxw1sjM0YEJlY278aRdoIXaIBrbOEkN8DBeKJ0rdlKJKLTYYjfn0aBT4T5aWQDmrZFs3AXNBHnRnkCymLZMjEYVYOYAHWpxtZB1PfTmk+kiQW/nY1/duc5eD9g537KYzeGOlyDXnKa13zQ6p0uV2KQ4LLwyyqhgNhuFlCg7VVEIs3dw1MXcpc6pNsDsRki0qDEzB0ADVDBLj7qnmAEH6rQ/dOt07UvMad2brCCuR8iRrjxthnh9DKlGeRMoZU0TUK+aAZphDfbqNv3G7g/gEisMyuVmnm7s7O9P2+/Dr4AYVEmvb0NTmFBQ1vPTZgUHho7HPPrwDGOXxbHlgiDuUm88m8nW+zDG59Lj4L+uj8VhC5OUThRaordTfz3HkNtCK7KFSWwxCDGHr+nhLGEV22Wrm+koUCKc+jBdOJQVV5NMEtqzDWNdpRBMJ1HYB1XZsh/GIhMXa44e5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(6486002)(2906002)(16526019)(186003)(6666004)(26005)(44832011)(5660300002)(66556008)(86362001)(52116002)(4326008)(2616005)(316002)(8936002)(1076003)(7696005)(38100700001)(36756003)(478600001)(66946007)(8676002)(956004)(66476007)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5E+TQhxYEpIoaqKB+PEPJzVujRTk2nen8kCNfLAwSGF5RrwDUC9bPF22gg2t?=
 =?us-ascii?Q?nG1LychOx59ZcdTGpA+IKmbnmQpdHzcDcau4re/vHhEHvO0xQFqUME1oswS3?=
 =?us-ascii?Q?C2TZBcIzwtaWP70MuTSDR3stNsyzk2SAx8Dt3WJcun/LSr0ftM1Wt2/T/2/f?=
 =?us-ascii?Q?USG/Ldhf+Smp51UFWVbruaPwxT5IEHvYHFB9Jdw3/vLjYQT7YEAsqwVrbHBF?=
 =?us-ascii?Q?oqgtF7a+9Sor0T90qFfex70CNbizOgopZvXHmgNOCtMHvju5C/YJ1bGXVKRH?=
 =?us-ascii?Q?4EaEYH/1058aNlUnGaNFgzlEmv1qGEDPHWmLVo0A2jxS11Yfex7rtsliZI0A?=
 =?us-ascii?Q?OM4lbvASdWK9EVOhA4J5igOmJpfgd9p/OP1r+89L7zfLb0fIHYFdGhgyj8w0?=
 =?us-ascii?Q?ERMXEObMMNq71Ecltvhqs9ygFpM/nD6vzkfQYoxlQeD7n+H0wWZP3DxYuqLP?=
 =?us-ascii?Q?WUnKKW83FY//4pip2toRHb+Jgmhqnt0lR2V5qeufJAIEZupuD2nCCQ86ixZe?=
 =?us-ascii?Q?EjfqEBhUakAaaqJU86YR/K46BpA739nOzx7uGMbUHvM5WWy0omJrsmGC4U0P?=
 =?us-ascii?Q?OiisG+yJ7IVeNLVlHAs77pp8n320piFI8XOUe78zSbgCKbA4R7nFjdxrOWbe?=
 =?us-ascii?Q?h9rFqHthPlmwZ6Gm3UNqX4YOel9kmnD+0Yk1FQJxooUfDz7PrWpREtYQBtnO?=
 =?us-ascii?Q?to1b5xpkrNSnX7dYibAUEUOITrjkLwf1YCfdmX8qejHIxsvBJZOPgURK0Dg5?=
 =?us-ascii?Q?q/QEZzMeauxJjHAvLZrLR+PmOA7eRzJ+LW5zRMVANfmbtgSIBC/Ig3/Nv8Vn?=
 =?us-ascii?Q?l7ODojJV1Gu5dazyLj8ghv4RMFYcxq5KYjYTbYCnUKfDICyxeoqVTM/LsoLi?=
 =?us-ascii?Q?bqXjUt9l924yjhStrbMgGBR+eBsvW4+8U52qi0yKHqeY9qXZYuxi1LeO9imd?=
 =?us-ascii?Q?ZGLWAdmOmur6DraYG1q52vEETbEGUZJus7S7QiXBBwtt8bN57rWQZMXQP80r?=
 =?us-ascii?Q?OFKQF1YR2LmygCZT/Yp8ymyoI72BoJPZX36ONT4Y9ZI62jpjuTMKVuP+osfl?=
 =?us-ascii?Q?bEgosqAWC57rP18bxZaaxcTD0eHN7eiQoV2Tqs65zSYgH7ru7NC5aSCTqfEt?=
 =?us-ascii?Q?T4bRT4wolJ9JlBnlYH8mLQb/CgsMkxduP6qx4FNAFpVx5XC7KwlYs6d494fR?=
 =?us-ascii?Q?Z/hzeI/fd4fYqsTHX6NKIIp4hdJOp4KkfU86luVYKtrKs9sQDU4+spfqYWvS?=
 =?us-ascii?Q?qkR7GIQo5unTjUq4hk83pgpSsLL6MELcWQ2hgl7fP8OAm/3sAU+Xe33Qvsdy?=
 =?us-ascii?Q?upc/uLR5a84am39pVnwWyVnf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a3fede-6b26-4dc2-dcf8-08d8ed6481ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 18:58:40.3116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u71ULm71LEDdQk1DJ8+HXF+6JSNC1QZeyUSpvP62vzNcDjZbdPAHO8zL1X4/oTY/4qAOA7O4evDYQl49x1EcHw3MdYJFa/3+pGzQ2ilOG0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=791 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=988 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
        1. Patch# 1 fixes the problem differently from what v3 did. In the new
           fix, svm_vcpu_run() for L1 first checks if the previous #VMEXIT from
           L2 was a VMRUN #VMEXIT and if that VMRUN is being single-stepped. If
           both of these conditions are satisfied, it synthesizes a #DB 
           intercept to account for the pending RFLAGS.TF. This prevents the
           instruction next to VMRUN from being executed before taking care of
           the pending RFLAGS.TF.
        2. in Patch# 4, in host_rflags_test(), the call to vmmcall() has been
           moved down. 

[PATCH 1/4 v4] KVM: nSVM: Trigger synthetic #DB intercept following completion of single-stepped VMRUN instruction
[PATCH 2/4 v4] KVM: X86: Add a utility function to read current RIP
[PATCH 3/4 v4] nSVM: Add assembly label to VMRUN instruction
[PATCH 4/4 v4] nSVM: Test effect of host RFLAGS.TF on VMRUN

 arch/x86/kvm/svm/svm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

Krish Sadhukhan (1):
      KVM: Trigger synthetic #DB intercept following completion of single-stepped VMRUN instruction

 lib/x86/processor.h |   7 ++++
 x86/svm.c           |  16 ++++++--
 x86/svm_tests.c     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 4 deletions(-)

Krish Sadhukhan (3):
      KVM: X86: Add a utility function to read current RIP
      KVM: nSVM: Add assembly label to VMRUN instruction
      nSVM: Test effect of host RFLAGS.TF on VMRUN

