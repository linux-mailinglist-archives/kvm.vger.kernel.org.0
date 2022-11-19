Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA58630EB0
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiKSMa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSMaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:30:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BE2B27A
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:30:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AJC5kI5023884;
        Sat, 19 Nov 2022 12:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BbFb2D9GAotJgJW7YAXjMx4kHDQpHLj+ta4h1/gt5Gc=;
 b=b1IszUqzlQIZS8Qt02EiomNoy9Wxt7e8L/qVHOc6nNNWqnMX/DjPSSG7E8U+kQPhrC0R
 ELLCOa9T2VMmGHUcUQkLh5iXtaTwdqjb272r5zb2sJJNdLacWG40JFpVUQCcwklZKVhn
 Vt4LA0DGypIeVFIBuW4CZcsLCf6CWzO/jHq0FC1sXKM7rdEPQZEcQ3JxTYAyhLRMdCvJ
 ylr8V5E6cguO49KuvTKsKo+YahvYxKxc8uYDwi8sNGW7HN2+BNCA2blpiD4ewSGDdG1h
 HXRdWymxerqekuN9IiS/G4bQGH6qBD+sKt9oJ44T/LymUZHdeMaetDPwrty3hU3kROAV CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxs57gewv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AJ8N6E3028055;
        Sat, 19 Nov 2022 12:29:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk7mefq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XU68mMn1mtscrWXKvX2a7Dt+xJHCbNo7NWmZykaWFjccDSeAsI1S0OXzLc7iZotH+buuvpgP9z+eoiNZj4rsuX5wn6/QsVLhx8xGMJPCnnLZxf2z/5pKUX5SW5mVrdb1oTKX5v8IaWj2coazunB31Q9P/e5DdtZg5UH7gw5JOlZhGzGA6uO2T1nfFaSAzskYQxq/gA7a+XNjRW2C0BoLhQGlOh2keVi1tSH5impuLcsrq0vNuGRMb3H2rbFIqdd22yizP+r189SiXqXaRRGBfnBMQ5dZ2vyo7QyMrx3iy9I9MJC9unwJe2CY9RWkOma4jvTVwmSYna3hEWTM/+/Q9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbFb2D9GAotJgJW7YAXjMx4kHDQpHLj+ta4h1/gt5Gc=;
 b=hBcNrPypu7opZ1r+neiAcl6Ma4NM9cPw/diV0sHe/UgudDr6fzIyX6lgeSZkVYZxKX1DysOd45T6nB4MRB1KiLZBSvxcpedNlNzUNHycBYVFSknXQUhRKWKYUbThdIB2kRkgJOlgitkyxb3W8qUz3FZw6XCOhGtWGpW/G9hM8MIOmeUPvCYodaJhQaBaBjExcUMD3RnoNRVqTlcYZXFZ2HHLGkkWKi3L48B0uc5vb1yhYqAwJ4c0XXXlcjP6zMkE0s5IxtEn/QVRxf12i9bOPNXbM+B/meE/gM8J6L5OX7yMN3s5zJ6CdGrwTH6Hx+mTrkzClNSaO9IpTF+oNka3dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbFb2D9GAotJgJW7YAXjMx4kHDQpHLj+ta4h1/gt5Gc=;
 b=sCrXpTSjDVscq9GqaG02GfiyNdiNV0DdM0hUyocuApAN+4nJhxuVJcBBZmxMfCwVsHZAL9TRxZZImcBiGCWcWUpY/6VXOI7xZlce/CayyixW8MbyEHzXQ6cBoRl8vBbLNU6ggIed1B4ydRqo2vCyhS5CDavJRXBSVVftsRUhG94=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 12:29:14 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 12:29:14 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
Subject: [PATCH 1/3] kvm: introduce a helper before creating the 1st vcpu
Date:   Sat, 19 Nov 2022 04:28:59 -0800
Message-Id: <20221119122901.2469-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221119122901.2469-1-dongli.zhang@oracle.com>
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b4d73cd-d715-46c9-414b-08daca29aa94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SA4watO3zqsizUKiOScAvQbWRk43sq3SHj0EgbClLL13TZSKPsu1jAfbfl3R93qWQTJezMg7MKgIS+MncUBlrxsG/9/YB2ZrfQ2JfGNcKKpfZ3/W/0HPj5PfSFtfkQFNkmIs9WESE89jgFt2rHEudrdWT9wNB7JOpTnB1y+UOgucHhxaK3Ux1eHIaOJYF+C1x4NmmvFrIFyKUx//vEnwMbEx7Uc8tYiVnykIHwGLI4JhN//u+kz3kZrTfZPxI0Wl0UkZbOBuGYBC90E4ROqlDgMoxHVCbDFYjpJRwQkHeja196giCls6xzLtXA2dl3aLPD9lvD3r6JaAr/ZZIcnHAwmX/Aro0k6cOlihP7yZUJ6yhop4C/pVZ6NXcoT/IPwuv8JrgxDB8ON7epvvxmstpYKrEwEexqLQjiskyYvjDetv0M9a0gaZwFMbxQE+DbykxQ1WbNJyoqyQNxjIgqL26WtdIerLvvbKj6QwdnUjq2+pMGf9Psnkvb1yZo8/UbJRF5QDhYHkByx2rnGE7VNOfq2mH6OYf9cDyzfR3e9uS3/6EFyPVo3NYMRg2WF5D7EwDGq0Nz56GqzHkDJFsPeTgp/BSFPmrA12Ipzkidj6/SwylEAZY4vkj1bQ5uKhtYmLl1hzH81+jkAAT/61jbTvzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(36756003)(66899015)(38100700002)(2906002)(44832011)(8676002)(7416002)(4326008)(8936002)(83380400001)(86362001)(316002)(1076003)(2616005)(186003)(6486002)(478600001)(66556008)(66946007)(66476007)(5660300002)(41300700001)(6506007)(6512007)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d11O4qMH0TKtdwoRT8wI2VgsvTLs00y2j9gcw/Xl+hpUY+EzRlM6Fk6E9en9?=
 =?us-ascii?Q?OCHeWCEfhiPCL77QH3NYATrdHDL/7Ki+f+iqeThLFW2GWKlG3tboQ1f5WUxY?=
 =?us-ascii?Q?mmGqgCvKlDysVffeQ4C+1qH3/MmJ0VTTL8Uz7cJQFh7pTEE/we2AoibWhLQT?=
 =?us-ascii?Q?lB/3YIYJA/qEX5Xtyf4CcySYPQ4ZEd3P1tAk1QYVgIVQrTSkVfs8hSdBPboc?=
 =?us-ascii?Q?z/aWyVPCo/FdW4Jkzjdd1h9a1Gn5KxaeoXNyDYrL7CdTu/USkaxtdp7fA4gX?=
 =?us-ascii?Q?q+e2l2UdRsxRsV0l8DXzlCwwxxiuXa50j6gWU1Q6NcjtVaPHppFiV+Y1ynO8?=
 =?us-ascii?Q?7tKmXJ1nuQ8DXFqN07dqM3iJY0sXOefShYo7+d3KYiGGpalVb8oaEm3WFAdV?=
 =?us-ascii?Q?ZiTgLhZV0SxA2hQx4XJ7lY5+Y+oNmCXJt1+0Ks8Oc8KC6Wen/VTqGrP2EOiD?=
 =?us-ascii?Q?yYcfpEanMxZh+tv8HpxROrtRAE78znzqTJv40/8IHaWhfKT/jND1vVsodVvN?=
 =?us-ascii?Q?VF7fDLs3pE/t5wIG9HpNPXN1/277omzG5/P+7Y0FbgHeAPQ4FCll+KwjSTsd?=
 =?us-ascii?Q?T6Io9ZHDrLs/CMCCzLIfT18/Q6AVYygpKOW03WM+o1kBNY4lkgRrDgBMvybI?=
 =?us-ascii?Q?d76o4mcM6y6ZmguWd+sK7sy8wzC+Fp0JIayhT2NSrbyT4ArBpuZXcOzwOMUG?=
 =?us-ascii?Q?/Hz/RxPYIAtNasIEYN0wDLHKjhCg3eCcgbfJPtI6HOuN++Sb2oyl0YXed+sz?=
 =?us-ascii?Q?qeNEGFtMgSGwGMlqjed7aTJKnbYM77+DOJLTlzccEiwQvPLddK7XFXk8H9PD?=
 =?us-ascii?Q?GSHJW7REFJmzj2yD2iTdLbFKq8f2BV/CUUGCLb4nCcWNJj8d2pTqC76FQbdU?=
 =?us-ascii?Q?0EdE0F424dEjDPVwxDhEzuo9sK/URZrqcZmJTY0y0z2mA2ITRMF+XcNLFKCQ?=
 =?us-ascii?Q?cAMz0cMJppSBR+I1pIP8OUYzHSBnokrdIrBPAYHTLswLntrBvAbNFlEMZ0FD?=
 =?us-ascii?Q?Qo+XsxdBpeiUl7ymsM/XvKXEar+XVG8JDLuMKY3rR56BrKJgSt8nftcegnCw?=
 =?us-ascii?Q?+8dnx2GEG2zh9uSIvHpdL78AjSd6K2uSojGjC8cKclZaEWMLXWdtJJ8j37sr?=
 =?us-ascii?Q?BIjdh267LrnsoTXJ7r7YK+2dRBwrH2HNRwG23QFTCGQLS65VbccWwE1o668R?=
 =?us-ascii?Q?o7f7mpneXUw4jSlEFowWwKJ7YBq/aE2mEgIJ1/jqns662txIJjRmiwOaK0V4?=
 =?us-ascii?Q?T4DDL7JJpHyfP3wfHrPyHVhj7MUWCIdh3nacmQTCm/jadq9QVSEdCovqrOCA?=
 =?us-ascii?Q?XFEpBYGs/T2YSpLO/bLum/ErzmhiNQpe5i8arNUiwLzuJgdF0LelqecMLkwL?=
 =?us-ascii?Q?j929ugzt09TrU6Dlpq2OqLUTOo5/kmuvy6L2fNitbpopiZG4+qvq9nUj/CBw?=
 =?us-ascii?Q?5R4g0+qH0vtN48e9Gt4mAsZ2HHs9jJeKHYjTtkMqXdVdFeVgOAssRUN7Qu/N?=
 =?us-ascii?Q?UELJJd/X1EQ5/Xl3sKHk4DJWU1DYMntAssGcyJ3Y2tuNZ8+B2YKTJIiIJ54p?=
 =?us-ascii?Q?T+P7pw9paxC73pSVWwcjveozqmu+XCDjT44N9oi1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?UNFXGtjQ9dnB90Jny2wKxkQ58qk0Ifq49zE+OTSm2KYvmJ/P8mm71iCV2bdl?=
 =?us-ascii?Q?6u8FY+9x+xRBy9eCs3nue37gBn5bsAuuOZNLYYOCaqdhX4omd38trj10r6zE?=
 =?us-ascii?Q?g64RZCcD+vor9eBZleL8JeAsDuA0JnUVDsR/oslCvYlldFbXHGy8jGJ4aKI/?=
 =?us-ascii?Q?MzM/r86cijCyq8j0wHtBRfQP8gTMXG0B3eam2OhCd5Je0bFNUtEmCGImxCdN?=
 =?us-ascii?Q?IrOvBf993lyJ/w8ZPm+BW0g0mqGRVXLt3KltZx35m7wO1Z6fUqIiHLL17R+x?=
 =?us-ascii?Q?60pNxhdn9iLTH29g7o8wljqr139p5AgB1W1yXCRJ7XnVAhOlxT3SF8a2VO1w?=
 =?us-ascii?Q?U/Wr1PFYmRxvDQjfyr4QQQoECXCV3icXChotgburpBsrwiWM7ZveOWTUWN8d?=
 =?us-ascii?Q?J5mB5ygy8QGAWtVuPGXrOk/wXrIKBqdwpWuEk3KyynCCKpZfGuZsdBFrL9a4?=
 =?us-ascii?Q?mAYh2L3Yz8B3Hlj+yuiwxIPD/Vh1zUHX1OcrjioFY1XnMlquQkAGwwsd2ybG?=
 =?us-ascii?Q?VBr2AwJE5riR/0m1ypd4JY79BYYh8Abk5vnRJBzBakllpDC82JXCNhAFfc4O?=
 =?us-ascii?Q?qI2S9pe0UZCgocm6QlSLPxapKYUvec86JR5JmzZrvno69x7695hPXRYHgZ/S?=
 =?us-ascii?Q?7ny8Ryq5Mpss3BWHMvjjc1gEiDf4J6g7SFZTPOstbby8lazy+TgBMCkxT3fG?=
 =?us-ascii?Q?+8N7L3lW2OdrBmUr49ipT2wcTWxHrB+jb0eOKEzp518XmBLNIy18vSInmFaL?=
 =?us-ascii?Q?X4rj5Bjh+zXeV4fjZhBYI34zEXS178ooZ5rIFDuU+AKhb1qfuzhrtEsVibBM?=
 =?us-ascii?Q?JuRlWVyBr13+JkYN+LQvu3BVF98j4lBmFpMG15uqxgCLAwrSRChgbCzwobeB?=
 =?us-ascii?Q?ioqRCmHLhadJOf2rD045yZ2Ublkx7mQgK9kPpLFF26kF1/Wd+yglYAYsgVRv?=
 =?us-ascii?Q?vInXgEw3CtCcCS2lXATflAiL9QXNars4eEUlgoqRgcd4zBvq0BhOXLwFagkV?=
 =?us-ascii?Q?kGsp4hAsKji9+gf5d3VWbDB9ToZNjgoLC7UVJBQNgVIu/7Nk8hqtmB1n/bXk?=
 =?us-ascii?Q?qYEWyiObUy9B2EAjAGm3m8yGe2F9kQLAwdvTjD132pTKu0tWauE9FRm5FjIZ?=
 =?us-ascii?Q?21EFaoNLUo4YpxsVTihdSfSEEYunEbNeHEXdLwwPs4hmQrQjLuAYp7/7M/tz?=
 =?us-ascii?Q?1VnMl8rbJQNSIS6tvBLHVttDLDmcwG1sR4mZxbpoprRGrExjWKYNO/0VHgo1?=
 =?us-ascii?Q?fhhOGOvk3z3BUDg1wZsxUSCI+szX7pFlVfBzj/+Y9mEKvWRwa/E3CU+MRP5K?=
 =?us-ascii?Q?Lzi5eGrbOzQ4FFVzQ67m53s+CUUPYuFm/pMq1uqCoKoa5vODS68493WvfqRO?=
 =?us-ascii?Q?gn60hG8Ig+92Sh25JxRvxigO7ZL6H6nlg8g5Y+rqXdRVASeOQZRfwGNyPQPi?=
 =?us-ascii?Q?pf3hU/UT6hxN2HAtj7rXvbB88kCDdi4y+KPsJkbNNYQtzYAXMemBl+yyF0sP?=
 =?us-ascii?Q?c/CnLCNs82ADmjdoWoQX30EMHRhnrCLA7R74vI+1/oepGA0kdR18CXI2MJGE?=
 =?us-ascii?Q?xYFsSj0Ziz57JxvXfsJ6Q0R6uVBxsHyWaXnfKRsPQ5HdwgwUEcYC/K4f/3bL?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4d73cd-d715-46c9-414b-08daca29aa94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 12:29:13.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EER7XxQAVRQtDFWKF0yDX5LS/lEEMVfxtEd7oRJbgRBeA/ws1BjirnVkWpyBoOyUWAgGZsSvev4h5jfWaJEUJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211190092
X-Proofpoint-ORIG-GUID: V7yPqHxo3Zz-xmJQqdDIuaQVTL5hXgMa
X-Proofpoint-GUID: V7yPqHxo3Zz-xmJQqdDIuaQVTL5hXgMa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some per-VM kvm caps (e.g., KVM_CAP_PMU_CAPABILITY) can only be
enabled/disabled before creating the 1st vcpu, that is, when
(!kvm->created_vcpus) at the KVM side.

Unfortunately, some properties are still not set during kvm_arch_init().
The values of those properties are obtained during the init of each vcpu.

This is to add a new helper to provide the last chance before creating the
1st vcpu, in order for the QEMU to set kvm caps based on the per-vcpu
properties (e.g., "pmu").

In the future patch, we may disable KVM_CAP_PMU_CAPABILITY in the helper
if the "-pmu" is set for the vcpu.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 accel/kvm/kvm-all.c    | 7 +++++--
 include/sysemu/kvm.h   | 2 ++
 target/arm/kvm64.c     | 4 ++++
 target/i386/kvm/kvm.c  | 4 ++++
 target/mips/kvm.c      | 4 ++++
 target/ppc/kvm.c       | 4 ++++
 target/riscv/kvm.c     | 4 ++++
 target/s390x/kvm/kvm.c | 4 ++++
 8 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..335ff6ce4d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -367,8 +367,9 @@ void kvm_destroy_vcpu(CPUState *cpu)
     }
 }
 
-static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
+static int kvm_get_vcpu(KVMState *s, CPUState *cs)
 {
+    unsigned long vcpu_id = kvm_arch_vcpu_id(cs);
     struct KVMParkedVcpu *cpu;
 
     QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
@@ -382,6 +383,8 @@ static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
         }
     }
 
+    kvm_arch_pre_create_vcpu(cs);
+
     return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
 }
 
@@ -393,7 +396,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
-    ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
+    ret = kvm_get_vcpu(s, cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
                          kvm_arch_vcpu_id(cpu));
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index e9a97eda8c..9a2e2ba012 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -371,6 +371,8 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+void kvm_arch_pre_create_vcpu(CPUState *cs);
+
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 1197253d12..da4317ad06 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -834,6 +834,10 @@ static int kvm_arm_sve_set_vls(CPUState *cs)
     return kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 #define ARM_CPU_ID_MPIDR       3, 0, 0, 0, 5
 
 int kvm_arch_init_vcpu(CPUState *cs)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a213209379..8fec0bc5b5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1723,6 +1723,10 @@ static void kvm_init_nested_state(CPUX86State *env)
     }
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index bcb8e06b2c..1be1695b6b 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -61,6 +61,10 @@ int kvm_arch_irqchip_create(KVMState *s)
     return 0;
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     MIPSCPU *cpu = MIPS_CPU(cs);
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 7c25348b7b..9049c6eb5e 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -462,6 +462,10 @@ static void kvmppc_hw_debug_points_init(CPUPPCState *cenv)
     }
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 30f21453d6..811f65d4f6 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -394,6 +394,10 @@ void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     int ret = 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 3ac7ec9acf..65f701894e 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -404,6 +404,10 @@ unsigned long kvm_arch_vcpu_id(CPUState *cpu)
     return cpu->cpu_index;
 }
 
+void kvm_arch_pre_create_vcpu(CPUState *cs)
+{
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     unsigned int max_cpus = MACHINE(qdev_get_machine())->smp.max_cpus;
-- 
2.34.1

