Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6C43467D9
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhCWSjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:39:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhCWSiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:38:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIO312166594;
        Tue, 23 Mar 2021 18:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=i0rZyBtFwvRWoPFtdiQoUiYVgIC4WBy0rlBONSY8vK0=;
 b=S8WF1HOhLKjdw1D/G07x1kkOmdw8CYONqsUpBnQJA4dCvFR+WmTRWhFfD6EdQ/JPfPM/
 W/eNO9fCM6wOgsKBlbmIUN0EonHpsaODckB0jSl2HbEE7qO/glfTBGO5b+sJN3uYGFQh
 wRuUhvXU3hMdYCskLW6njq9/IOZ18hIahYNzp+H6AbAq/NvliS9aEq7DinO8gi/riYIo
 2uVuyvNA9qCo4W86FBn//DnywkZHoJXyRkFd4AAkTg0NS5YMJTgR1DNQMGBsFQ8RojCX
 NdeomLBXzi5VqDhCVu54D42uae+MdeDDjCMgZ257WXFnmzldcOnfe25MUVkMu+CWXp3Z gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn062v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIQPSt075647;
        Tue, 23 Mar 2021 18:38:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 37dtxym90q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN7iwbxMZcDunRyUnOlyh34aHSSUbH4QxBxJY+F0pIgCShhqz0JBEA4MKcoIEDnJhDR3qGg27lW8m2zscrhwqtq3komn+gCvcOAn2tme3LpHnMPMrBf49w3oGpkTj0AB8VVma2mXlqyKxwPCA/GSiAWq+R7IivVq0Ekt9PevLTDYqemPoMN09lX28FbC5UGxF/wMzEfHOjqWoxMYfEQ4dsrUu74ZQpbI1/RZPQz5BdunoVHKgSjeIVR49yjBn8IN5KYPi1XCTyTAXsnEG0abFMgccdANT5xPlb2c3BCHfWniak4PQCllO088oWD7NIJG5i48OGgN1EFQIAkdPghJgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0rZyBtFwvRWoPFtdiQoUiYVgIC4WBy0rlBONSY8vK0=;
 b=CA+4EcyV1ezQJXlqhIWzRwNWDpnj4luuSCxWSiCeJNW7j/IZmFJRgLfS7TYJ7w3FKaUafnO0//5DrCfA9sJiBNFqWm/pW7Vsi6ZKfDXP4Sn3n4QjOpJGVkdeKR/tkqPdLOEfxnVcq0rmyUYywKoCrWqCywemy4Sn2FgxBP7miit9Uhvxg97uHZxHNhxZpUszXNTtWoJqIiPtRmBZOOyVyIM2IVjUVRcZ7VLIEf0fr2mvirhQzzr3tnBc1wwD31aYVRuaaSYQ/feVIlIj205OMCBd1KU4h1ajrCBkQfyHoiMopGS0D5Ue0j4lWvbwC/eLGG12V9bdlaj1aWZdb4Fy/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0rZyBtFwvRWoPFtdiQoUiYVgIC4WBy0rlBONSY8vK0=;
 b=ZAMjSQlE3GaRJgCoWs8AtORWMUHv4PrSZ5jsanVFjYMLrESkdfuric4+MAYPbumBegRgsXw+2FS5CweciTJA0+u2W7WxcLZl6IjIQuK/9ubaSam0qtsfXmU5ByLvuwXRX9heFiexg4+bD7Uac/zG18+0g0BzpIM9qN1u/P/n76k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 18:38:40 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 18:38:40 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/4 v5] nSVM: Test host RFLAGS.TF on VMRUN 
Date:   Tue, 23 Mar 2021 13:50:02 -0400
Message-Id: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c410bd3-649a-4e62-53da-08d8ee2adfd9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4508:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45085252B637B4E3509AD1BD81649@SA2PR10MB4508.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DI8qMnFgbEwFbSZH5wRzRKlITWCh473KZy1Q8/K3+H1dnTZkdj1/XnPQIwZphyXzQX5/TIkmitFngGSITbCaDkba2u08/N0vNQv34Povc+7QVpfKCyI4V5DUn/4v4UejMHWDYVkC6Q8JirJbXyJV+Xu0WYTZqMA3Ey3vfQTTGK5pMTxLA7ZeBRFchyLZUxw2glFXz8Z0zR2L1aQYN+p/SZ5LnC8NNLf/7Q/ClmKAY5yUPa9B2QUeY9Da7A/jZOKvttS82m1zk6Bhv/m71GvNb4Mjj7XP64aJWwgeIiyhHk51//gEjEowlYEcS0qgzBNr8KKzub9WdJaq/eoNbF2eJPFuQ8KTa59vLuPDfmQlqS0smpLURt4g0ptvtqOo53b9pnxJFP3kljjOjcpzFmFYYMfDkvi8OvP37UOmRtKF4YBfQ+T2MDAVtBQJsft4paxUh2VIoSSUY8qq7I5VEr3VQJDKQODLVwAc33BL3puHwy6NWz5n5WEURQf9+0i5oyFSAduSzIUV39/DcdY0ycMZTZARmZ3GoxjxgFePaasSRg9iF5T7K2bUM7Xv6D74HR7qUenjtpZGPuC1qhppOqhPwbKMD4gG5h5yefcw6MkOrslRBGMCEcL79lM+wnsOVHHkID3NHC2X52hSvRhpo4e94A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(44832011)(1076003)(16526019)(2906002)(316002)(2616005)(6486002)(5660300002)(83380400001)(38100700001)(66556008)(478600001)(66476007)(8936002)(66946007)(36756003)(6916009)(7696005)(4743002)(86362001)(6666004)(8676002)(4326008)(52116002)(26005)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NaO8Y7Ljkre4tsbywWGrhSOjCSAStQ0yggONerKcEO86ZNZQp2gavQJFayRQ?=
 =?us-ascii?Q?9FaTcWOntsRXkq4JxlsD4DHbirKc8jyOodIE6Kve6H99tCIrsS4la2AH2gEq?=
 =?us-ascii?Q?nMXq+GB1NK2Hm5glrup0gPRw2GpbvUlI/ZHVVq1B6s3dlqE8gc9DOv9QVqZD?=
 =?us-ascii?Q?d7WsIalIVLsaPia0i9WPD34uiKWVEq4wfAbKYkyMoMKYlBkd1fKd5AKSxfd9?=
 =?us-ascii?Q?OW1N6S+uwbKBPQok2GUgnL1HioNdesqxfBwO8+Z3L+A62NHAXAbjA56vnaJw?=
 =?us-ascii?Q?Mfr2MUsrR7LBryEB4xL5RmBdwICdbl7x8OF0f/RsJ3wupIbQxKmzy4UFckFe?=
 =?us-ascii?Q?fpFGNSLVJpA0xEwLxcV/NRHEOvpthyEdVk5GjMfH0rKTvDqYa+DcXHM8is7/?=
 =?us-ascii?Q?zTqXNnlcPXAyuBYOlOpvpdi2fpqF77vnaeYRoo7T4VB2JxXnlDRTEHKGlU/M?=
 =?us-ascii?Q?TI/VMuOMnKK7IjOgtlkgrgfC2newOQA/SFhzu96uGU0AKzYXgwpCnfQ0DYrp?=
 =?us-ascii?Q?GrJKCCZteboj64beM4YBSUmlz6OA27B2jj0UMYcZjQ8f+dCiINzJAcPjef16?=
 =?us-ascii?Q?7jiOn8QaT1ci5BjzFtTzEmE8YHoNpB4MdVqxcgZPmCiQB0ue4WrXml3xs01Q?=
 =?us-ascii?Q?Oo9TlUPkm2uq6BmQuydTqCHrMXWIyY+J4UIQl+LbND31yWo/oxefe+eurmGM?=
 =?us-ascii?Q?zQqWsqonkzJsB55aLTGKQjkjNxKZptfkhnsRBo4bLvJ5h0TQbS17zzw9LgKL?=
 =?us-ascii?Q?kqXNuPpthzE9zdtZE8FqGH08IXY4mrn5OUyz6Yy0vinXzmz7NvdXN3EFhzEY?=
 =?us-ascii?Q?aAXEkDStCBYnZ+Db8ERmxrDiavE1990ILhvjPXK9FmtSYMwgJTxnDo+7WdPT?=
 =?us-ascii?Q?LbE8UBaLlP1U2GIqZe2jP52JM+rYaB09ogXfohrVERw1gqZAYgs+PjHDZ8nt?=
 =?us-ascii?Q?YIEURuwincLqiawAGR9EZDcjWkIKMmIlC/rZcGht0nDoi6EtiXHYUK1CW43T?=
 =?us-ascii?Q?WSGNfLaqB0aKUA5f8EWhUO+3+aHrhQo1eC/xq+z7yAmkzfmCWqQFJ9FXQhV5?=
 =?us-ascii?Q?ELt0jcmjbEZ589ZStou/eC7L2EfxJSEduiBl4KkfiRO/BRpzfwtFNjVPPFrT?=
 =?us-ascii?Q?UQtrBFCT/jZyy1kg/Sn8QOLw0uehnZw+UsclJZ+yNwkfzBoGj4KhaB6HfwRZ?=
 =?us-ascii?Q?0jGe+t2ZEIklg21exFI82lpQZGDwV+0iHxqUFYBg4/VZD68zIjoMFD63JViC?=
 =?us-ascii?Q?ruhbHeRmtVlVeGVp03dITDfToPRW5IPwVNxPl7PpbDlYIp/1moMok8+Nsjtp?=
 =?us-ascii?Q?ajQpy8xdBzY2MEziqQhg5DXF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c410bd3-649a-4e62-53da-08d8ee2adfd9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:38:40.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0u7nCOC/8XJEIf/TEV8ziShYK6jDCw2v4cj2jLCpeuXFBMFXkpm67uP2L2IlrHdwXxH/TOBb6jWicNF1bFUg9UD1u0K75HAYpiqTUA3TdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=970
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4 -> v5:
        1. The fix in patch# 1 has been modified. We are queue'ing the
           pending #DB intercept via nested_svm_vmexit() if the VMRUN is
           found to be single-stepped.
        2. In patch# 3, the assembly label for tracking the VMRUN RIP has
           been changed to u64* from void*.

[PATCH 1/4 v5] KVM: nSVM: If VMRUN is single-stepped, queue the #DB
[PATCH 2/4 v5] KVM: X86: Add a utility function to read current RIP
[PATCH 3/4 v5] KVM: nSVM: Add assembly label to VMRUN instruction
[PATCH 4/4 v5] nSVM: Test effect of host RFLAGS.TF on VMRUN

 arch/x86/kvm/svm/nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

Krish Sadhukhan (1):
      KVM: nSVM: If VMRUN is single-stepped, queue the #DB intercept in nested_svm_vmexit()

 lib/x86/processor.h |   7 ++++
 x86/svm.c           |  16 ++++++--
 x86/svm_tests.c     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 4 deletions(-)

Krish Sadhukhan (3):
      KVM: X86: Add a utility function to read current RIP
      KVM: nSVM: Add assembly label to VMRUN instruction
      nSVM: Test effect of host RFLAGS.TF on VMRUN

