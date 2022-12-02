Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A0363FD1D
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiLBAcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiLBAcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:32:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A325DB0B59
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:29:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B20KhXe024390;
        Fri, 2 Dec 2022 00:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=LyDgQXL/UtnonQnN44uV7lFYJ4T2U1SpEISrlmGFdDE=;
 b=FO16zGfmlIRSm/qAiE7biJwWF2PpGlL8C4l5/oBHQeq/peZjjnGvigJLmyusKM+Wc56d
 fAUYIkDx55iV10DFPqawkAHPSXkHAxWFSc1IxjRAzAPascT4PrFGq67KD2li1MGuEaLO
 ZAZsErD/J21bOiMiUqhxrbam6VU3/ps7w5pbVQWH0h4KyqsKoxRIvqhlry0KHzEH8cfw
 HmmGpuB0CsKpWg3k2BmVVj13AHIKokbtKPIA4PsNaQDTZqsk+Qg/ZTIayhSiHmBoPfw8
 X0ZGVWMdApibLvZiDJrbEol0h6dpZ03LCwBDU7elEL/7vOGy8EnCpdHWNQXkhnCPHY29 Fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m76f0r16f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:29:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B1NwnAB016310;
        Fri, 2 Dec 2022 00:25:26 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2nmjbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:25:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWVVGtu2ekFDgGFSYU1LHXuqruYpI0X4GUI4rpmoUcpcmK08QDf/Gm348aBl8ASoP8YO8KDFE3/sWUbFV5TBxVvuHO/GGsbzfT0qegAFzq+xo7Ii4e5yVeiP8lJl/eMyMrZaebqVPmosoDPH8yZ0VxcxCJgCZGy16ML5/C79C+SIaJwwYVrEhlgsw8va7J7JqLg1BasMu1Yxv5dHQh0uC9/KRhp2s1JGrwickWWEhWBxlQTy/kc1hK9KLah3Nvv7P+P+3++QY3odskskp19dwYpKTkBx5+XcUfalysrsApxnw020MoCLGmcEPswpjweMprWVIJlyz+mOQ515zyZg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LyDgQXL/UtnonQnN44uV7lFYJ4T2U1SpEISrlmGFdDE=;
 b=IKBmzWKOOjeroaRLn1cK011nGiFb8ZCYytZ7+aj9bLNngTh+XZMT0kLyptR0QznOTkAnWln5FMoLoImgC+Q4ZkJ8gRitUib9BdgYkMurR2KRyVpSlpbr0hPPxrw1lenb1WOMTPNk4oUQrfuuf82IBOXBkEFA7+epjz/bvpfQkn5D2nU79AGHqOZ3tIbgX+5DCNjFSR4g1xmosNPGY2lfVoD/6sqAjTNdW5BoJC8KQTPX5uqxsfC9fdALKhOMbN44n2VWxSdGRBIOb9JlS5d9tN6+s4QkgNk24wweUAGr8+0tEXmONxDcYCwbexoXFbDHCG4TVKyNeFwcHbrCqs8Oag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyDgQXL/UtnonQnN44uV7lFYJ4T2U1SpEISrlmGFdDE=;
 b=iaclhN0YOO+EExqxTj9/q/SkG/992c/FiAO3odhm2CDcfIydByoRw2plU0i65MC+xl2S7x815IhjvDoysuobj7c35ievKIVUCJDN0FMCsO0DNLPAVdlGMNoED9de2h5LMtmQEZqwbsolC4Sa3YKMprfpukJT2f6sV8zbkejUiu4=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB4396.namprd10.prod.outlook.com (2603:10b6:5:21e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 00:25:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7%7]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 00:25:24 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, groug@kaod.org, lyan@digitalocean.com
Subject: [PATCH v2 0/2] target/i386/kvm: fix two svm pmu virtualization bugs
Date:   Thu,  1 Dec 2022 16:22:54 -0800
Message-Id: <20221202002256.39243-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0149.namprd11.prod.outlook.com
 (2603:10b6:806:131::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM6PR10MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: e764a86f-c619-44c9-f798-08dad3fbb41b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cgv/R2GDDmzoFZyhBWnG4sdfHBrqRm1pPPSd7EKtLhphyWTLpOl1xpbpT79uXVcMbdlbxYEIIEpuvlWTA9H5/u2IlOo/PcOWNvjUnlpXRf2pBK0fneNZfAKhi8mNaNr5JxBk0yqRaGzeCZOUkqoMl7k0Sz7gh2/ZesoZZzkkdA1X4vNrgX/wzX/IOo4UcrcukHI+SBYVul3vnJpQbvx/FRx9cvL3rpTxu0iMp95lFZt3VoJRusN+1KPsXIVTvAqu+O+YxVS6voSzG1I5Tdkx233R9GfbOYtuKhYv7UfRvNsVPg9K1vf/8FwzgKYxmRY0LNyZP5upP+gW4iTdWNKdKi3PRw9sOH3++1ixtFhjy1ByBwtalIihKW4owTy+Ye9uSGhBppH7/JZEJ5Y37Pe09GDTU/cvMvwYKbe6BUotf6GMz8g8AyLyIdq0JtiMitHzDR4SRcrlVp0MIFFcje55wmyQ0yI7By8TSLkox3CFNi1ZopcnWxwWqmZBygr7dAd0ve4f5SvrXD8OuoqCea107W2lkLFzurW//PAP5FkEpWrw7I64IprGPepDe10AZJd45K9kcyYzv8c6+0g1SY35CHPhq0XCfn+GEcp8cBLf7wD/4Lys3DV40cwyFdJKQd78cViq4DGz4wAwWIdwRrNqhs0OXbmEtSzlTQs19+i6yYX2mRd6qFw1OLzePUsUeCX8S7hneMAC19HOJcg70YYYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(36756003)(86362001)(316002)(966005)(6486002)(44832011)(8676002)(66946007)(4326008)(2906002)(5660300002)(41300700001)(66476007)(8936002)(66556008)(83380400001)(38100700002)(478600001)(26005)(6666004)(6512007)(186003)(6506007)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/K6xDyVuhZU42LhTIaT1XTyS96v0ERqXRm0nhND6cWdBJIZyGi9KPX9aS0JE?=
 =?us-ascii?Q?YCT3+V1ErLY3DKz2RzNKp2VgIrrvQ7iwfPjB9U7q1GaNAEE7/LCGvlmkTjec?=
 =?us-ascii?Q?c/nZDk/V9sX4JSecw4Ki5a8Lcw3AkJiQ8hPeZ1NZwuqy0PobyIkBuv7psw+0?=
 =?us-ascii?Q?pvuvPp+/BsN0DvAk3EOI4qfo3Ct6n+r4VRR7PtCjVkkLLvLpmMFh07zfR6Kg?=
 =?us-ascii?Q?3OlALSgcfO1i/E+qoPljQG0eTks6xQU26HAnKe4rZfBD9xKYvEVFBdLjm0YH?=
 =?us-ascii?Q?yLc08loKlZ34WPwyONK6/cS5DcC8+OAMY5TwhR+wYQIIvLZrFGI9FQX6NyZw?=
 =?us-ascii?Q?yphB4kLk5OYt4YAL1DUOdlbefu2oSJEnf4Qh7clCiegTZyIpwrGYmxeAfgzS?=
 =?us-ascii?Q?9L1YktWgBc9ywHar7zx/vvWZr3QtVDzfJydAr5CpbNfz+bJ5we2n4XU7JkhG?=
 =?us-ascii?Q?jYC0IT0Jr+3fvt7rbN0Bg/TANZHkQyIjCjMQX+ngZZIJDIVBmu3IaeH2Xv3Q?=
 =?us-ascii?Q?xRSoUznzmiLwBNOhjhxLNd2YUF54/TozbVWKViJZ5SQOHfkiNcaoZuyjpOb0?=
 =?us-ascii?Q?wx8/4TLeBI44hsOZ2mFUM3OP063C5qsgrtWzoy/zci353KUhxT82O0vjJrzI?=
 =?us-ascii?Q?yMiAwUbKhPNwwZF0rAffsgaxJw3ZeXTWZoMzZkIx5//V+dB4w+1mgLXPS8Wb?=
 =?us-ascii?Q?lxiom3S8b4xlXnNPT6e3l4/jyZUhOnQ6U8yu4AVFosBPRpemwDhT9nRNN30x?=
 =?us-ascii?Q?h0so6clUZKHiY9U+I3P20E+HxDHegrYJMpAny5KUnW91V2huAP3vVAEEMBav?=
 =?us-ascii?Q?dniDij652CJs5GrwBe0l5m9Hypg3NWUytdVrfKOLlL72fGmQmwoOJiVCIPUz?=
 =?us-ascii?Q?kjrVnXQg1NJEGB3LAssg8R+Oa0pRQwLZLWai9XCu3xMKEbsqlr0UupEjzTQX?=
 =?us-ascii?Q?fJk1HqfLtE3aIV8FQcPYti1dViz4LOg7RXkVRnTl4Bp7xnG8suzuCmuKKEiF?=
 =?us-ascii?Q?dm3NZgLZKqZUwuGDyvSYVF+H3VXUa6j3UpP/9f+/irDTTYCpoSKRD4ks4zNZ?=
 =?us-ascii?Q?hiOyuOSlKI3o2NuK9XJk0SyfT0j8m+kEjNKb3kFnbd2sNRTV6Srh8+49y5bQ?=
 =?us-ascii?Q?UZpLIndvYL+kL3m0idmBWNDWZ8OfI0CBNOCwjSWlAuGoBwU+Xbi51Mq9eDxW?=
 =?us-ascii?Q?iC/wNPsuLU0QBkkIaVAVVWzvfrZQSUjcSWqWA+RVRMC5UYQGO9A5DdrMxXrx?=
 =?us-ascii?Q?0+mtL+xMtkFoyjXBCDhFClgwv6PzKevpYodj+qVMfd4o2SMO/r6+mAlqW4aM?=
 =?us-ascii?Q?/FMS9fb7yo23inRVk8xV1njiHOAKJ2ZijeGOi31V72UbFty/jy6zrAd9g5I1?=
 =?us-ascii?Q?9u10/S5+60fEGxxtC/7a/C85YbE7lJuYyyGhKn+bESUJBdhGea4jYWdjsEJZ?=
 =?us-ascii?Q?jvhSGgAVv80F1msgOo2+BArh/L0SHGLpuWszrvlFHX9hdjPeVCQDqleToo0t?=
 =?us-ascii?Q?ju/Mz4ZGgG3GELxcesC/xUlsizd5TA8Kh8JLSPVDD4U3bE3RAueEWvNP9qZP?=
 =?us-ascii?Q?E6ZzBFS0fZr+rLyQ6IwVVuEHZDj6C0rctupg1soC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?cpBKxYfLpY8Z8UCXQihKlAPwwWntCLYZ/dfEY3WVNJANHYISoCfb/OOKqgtn?=
 =?us-ascii?Q?Bo/jzlP49/agJZkg7u77FnJtv7+PclpIfwHTz8BO8SDVhepVJ+FUB8tXEUjC?=
 =?us-ascii?Q?h6NdKX9MP95pLeBeMo4ramfO20dZigyGiBYRZpE7g42vpKNk7kMWGWFO7H0C?=
 =?us-ascii?Q?4HdgR10K7JDjTkZLUC+YxJPL2IWf0WKmX0rqjent+mdD2KtjAiHFAG9469D5?=
 =?us-ascii?Q?CaHYYXHyyxtBi1VE4rznPRBG0DK7ZYTseWO++PW9NwI8x5AIDU12AlqIRu3y?=
 =?us-ascii?Q?w6mG2+vuFKg8okISBj0XYcEI3vWgGBFLUxk6qoOUmiHRWKF1GR6xWrQOfA1M?=
 =?us-ascii?Q?LIr/XCoLHfMmYWWcVQaxJNiC85oUorJ4NEiFwLSx8EozcY5WLhxehGu7JQZX?=
 =?us-ascii?Q?k8OkUS0+ZddsLApy/sTtLyupm8m61b2NVYhkqwHyQW4Q0YP+6JWT23PTpBzI?=
 =?us-ascii?Q?t3xO9TUBo7QZCPjg4KJmC7hthiEiz3A7FiSQ66hTpQ/01TsaQJti7V7Ruwom?=
 =?us-ascii?Q?SgLewVsM70C5+4LPR1nS/L1y46ov4AONt0mNPVq8RSoQS+QrXoqLhYiglOVm?=
 =?us-ascii?Q?b6hL+vvKD84peXNxPkfdMh1Eb0Drbg2rATC99KuTZ+n4mfY64AY1r1zRPVc7?=
 =?us-ascii?Q?czexORvo97lhODRTnkEEt7/1XNxF9r+aBhLQfw6RNBbCIWk5QYKLZBmzW83h?=
 =?us-ascii?Q?kbcVwrgneQ7HBpxQg3Vflx08Fdrq5eWiDL8sSUpYo4ebMyjVllSrke2zMJEL?=
 =?us-ascii?Q?y3cOX9aSAXr5HyZ79pPBooPEUcsOupdwr1dBSBZmJKOSHi+8qnaV06j6RCR1?=
 =?us-ascii?Q?v+KKRVXpDKl4IAPJDV7lGl2U41HNDuNypXrWSKAP8qnpCZAnwn0EJmRNQD7d?=
 =?us-ascii?Q?W0M096G5lvS5lUAu79kuE/tsWOXeTkPwpkPgpW5ZIpyGs905jiZrcTjJwz25?=
 =?us-ascii?Q?lZHX1SftQ3ld1qGpfdX1Bw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e764a86f-c619-44c9-f798-08dad3fbb41b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 00:25:24.0361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7Tx/s/O1tLpL0aYYcmx6iAuhopQcQkWi+MFI4Ir1/0nCR1jR0i+C+QhP0r80y1VYsdazF3awqammvQdcemYZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_14,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212020002
X-Proofpoint-ORIG-GUID: nfMP1LCbRVuDxyXLLGf55zJznqM1ZClQ
X-Proofpoint-GUID: nfMP1LCbRVuDxyXLLGf55zJznqM1ZClQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is to fix two svm pmu virtualization bugs, x86 only.

version 1:
https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/

1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.

To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
virtualization. There is still below at the VM linux side ...

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

... although we expect something like below.

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

The 1st patch has introduced a new x86 only accel/kvm property
"pmu-cap-disabled=true" to disable the pmu virtualization via
KVM_PMU_CAP_DISABLE.

I considered 'KVM_X86_SET_MSR_FILTER' initially before patchset v1.
Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
finally used the latter because it is easier to use.


2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
at the KVM side may inject random unwanted/unknown NMIs to the VM.

The svm pmu registers are not reset during QEMU system_reset.

(1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
is running "perf top". The pmu registers are not disabled gracefully.

(2). Although the x86_cpu_reset() resets many registers to zero, the
kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
some pmu events are still enabled at the KVM side.

(3). The KVM pmc_speculative_in_use() always returns true so that the events
will not be reclaimed. The kvm_pmc->perf_event is still active.

(4). After the reboot, the VM kernel reports below error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

(5). In a worse case, the active kvm_pmc->perf_event is still able to
inject unknown NMIs randomly to the VM kernel.

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

The 2nd patch is to fix the issue by resetting AMD pmu registers as well as
Intel registers.


This patchset does not cover PerfMonV2, until the below patchset is merged
into the KVM side.

[PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/


Dongli Zhang (2):
      target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
      target/i386/kvm: get and put AMD pmu registers

 accel/kvm/kvm-all.c      |   1 +
 include/sysemu/kvm_int.h |   1 +
 qemu-options.hx          |   7 +++
 target/i386/cpu.h        |   5 ++
 target/i386/kvm/kvm.c    | 129 +++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 141 insertions(+), 2 deletions(-)

Thank you very much!

Dongli Zhang


