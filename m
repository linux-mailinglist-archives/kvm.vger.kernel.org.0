Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF3310184
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhBEATL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:19:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhBEATJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:19:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150A0FG185098;
        Fri, 5 Feb 2021 00:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=04bUjVQ6nltmBHj4MxufNZyb3/Jt7HHmSvrNUlKXMlI=;
 b=nTb8kVDgWj5DP18rSw+m8wwDmjAPYXCpw73/zGZ2IxuhzTjZljX7s8us7opPK4dqcPRS
 b5En3wixP6mGiWvUSgd5kVXWly900lrRJ7coo/KZ2l4EXOeNn52NR5SHGtlkHlM/Un/z
 TeLGi38+0hGwToVXjGEHKONMJ9TThbCogWgSIyidCpWWLofpYwsLZDLpkT9eDP2zqB1b
 Tq6xIDUH/rBX5MTUycstE9g4M8w1cNiJATZ1TwoWc7ZV0J6PVnHrbYu9G81Cs8xD1OQA
 zhPrCw3F0rXZsm6K7Otv6iq6fLOzrNBE7yrRb+HylVJjO/UWf10wZBexBqWRYNcNeIYT 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyb7yq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:18:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150B80N080842;
        Fri, 5 Feb 2021 00:18:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by aserp3020.oracle.com with ESMTP id 36dhc3djm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:18:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgqFlmWfT0uld8ysVPrj0lBn203usm2OfUmMmLcZq094YdLF72D8ENF6TpvV3GM0I6z2FUaR+s/vtLJJeSeqdDADv56/gb8kLK7vu7CR2pIpP4Mcsjgv17d0YhnS+/kmRbIkdG9WiEBwm3JqdXX52xeMk6RFkDNQnDuvIosl27SJNaN0g0ke+pVV5trnGc8HvgJd7saBB2IeSi9KQFTDdsGd35Y+EGrQLIQ9qfRwKm1n9xte277tX4FrRDqiJCji7MVXo+51+SfU4g7rMWtjbRPLoJCH0+OWIbfhx2CFcOBTswLzxB/4NWT+R7i1/g4l1D7dErFVXaI/3grijnn9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04bUjVQ6nltmBHj4MxufNZyb3/Jt7HHmSvrNUlKXMlI=;
 b=GXwVoaV0tw40D9DzZfN+UMpgOPCRuJbEINrnOLqKp6SkEbTZJL72lAENX6th05eQjEs8r2P2jo8rCC1rpyoqVIt8mjSDVpxFsc5VcX8jgi3by3PMp9m36855db2lJtERjEK/hJaPH2zz44K8IvA/iEXquYTaLRWR78JWcYiqpTrVU3UJaBOng7Nndw+0CBJ6/+Najuc0KHIkwExbwvF+NWSmBm5wt5UrrFkOpatWZ2A8oGXWlmPy+quQKIcHu3lJ7c88Gvn7t1ieOpJYMVglM03OleVYegXDx49J7TMhyDzeD2Fh0JvoyPOMYK3zhFja56ELCa0DksyVKPwY+50+3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04bUjVQ6nltmBHj4MxufNZyb3/Jt7HHmSvrNUlKXMlI=;
 b=qc+WlaFJ/zs0ZMQjOlYIujScFbaya2S+JfgTeq9bo+PeSjtkngzGHj6jOa6+yCLSv0IONky7f5yc8WphhXQX9Z/lL12euaddFsfKrLujk/Tr1I2sD2mpC7radgG0xMRul+W+Y1nGcounKUaNfkyPzhYEfSc7PZU+i7jKjXr8+R4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 00:18:22 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 00:18:22 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/1 v2] nSVM: Test host RFLAGS.TF on VMRUN
Date:   Thu,  4 Feb 2021 18:29:50 -0500
Message-Id: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 00:18:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1e87fe1-b055-4018-f220-08d8c96b8c20
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2717AAFEBB345EBEB0F5295881B29@SN6PR10MB2717.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFAPe9Ebip+/N6EIu7CDsnORhSICzyJlJnxauQ+kT1iIA3WfNrcl9MLdNmQZcronwsl8ghMJPLgvmmTlQy4UlbOFURnTpS5oBXFZNoZn5mNwd1OiP7jjDGT+IZTHnDmJbd8iv5EOqKRD7ulwzl4IRKHJ80/z3dbNzzXFevt3M8rM0l4gwgExrxi81NXXQFxJplxsXg3dIcpdXP3d672Zx+TznLs7hZmggtcLZoAEFUoGPCHzKiR2IXS1DWe/PdYTlaBy8IqqWC+ty+BNQ2ZgOL8e7J+CxCa2FPbHfd0+qKhn8cYeBzBS8abK42LP70JyS5e2vktZ9NUryuGqqY1ysPprTWRWPe1UV8Ea3HUVZ1FJvghskfNRM2EGaGycrfYgXXYW3lQiJHVDAiTYoYEKpDgGhW4iMVmdLVHdeoMHd6uDeZaFYRdz6RAbvjIua5hr2j2dwRzv+LkjqTGcStXKxPaIokgd4B41of08JRnGJ9IcL1vuTjdljGgubV9NgKrCn8nbOv/OvvAKCXZ4xbIwaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(136003)(366004)(83380400001)(44832011)(316002)(2906002)(36756003)(86362001)(956004)(6916009)(26005)(6486002)(2616005)(4744005)(8936002)(5660300002)(52116002)(8676002)(6666004)(4326008)(66556008)(66476007)(478600001)(16526019)(186003)(66946007)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VlHnH467flR9EMbOiu1tkSUzfQVYdQcLMc7vfu+XEYD0crArbO5xRn/a7zgi?=
 =?us-ascii?Q?0SQ0yD0IsxqgjLYXgwxED4EsyxIdY6+Rkt/haGCM75sutwtzHOxxFPkPDo1e?=
 =?us-ascii?Q?baooA7KSpf27WtWLqdk359fjr18deU8qkb5zR/A1Em0fQtlD51HdSJg/+Eby?=
 =?us-ascii?Q?Sc2VgG5afEabw2eMd5yBSGt96vcb7EYSlQpg+lZQebXgVDDKQHKAViDl1GUe?=
 =?us-ascii?Q?SImOhimyBOBjUScS4UEnQ8FTvaKwxoAqMxsHepswnI35VwsXxazyCBmtuDPv?=
 =?us-ascii?Q?Efa2ln6cT2qijbTp4NibG7Dl26Jd5OjAyMxmfNFGjhH2viO4bMxth3thFREe?=
 =?us-ascii?Q?SrdpUj/gluMb89XgAGSKda0VNZNybOCsYkOvDzqZFYG9ak5WDo/iNkz4ejxj?=
 =?us-ascii?Q?bYJggry/+POY9rCU6e4XmClHO4Odtd2K77s/aVzAs98S+h4ocj/UugAkixFA?=
 =?us-ascii?Q?idl4RmZcpk53Ve6QtfvDc7jqdizi/19ODAVYAoSfgxy0if2KxX5RQG0nzX5g?=
 =?us-ascii?Q?pLgG5pVB5bNNDS5rHdJ24THH07M0bJfVcuEYR9BG6EyCptkkr2YAzSBjMJB1?=
 =?us-ascii?Q?MeDHnjTeSHGm0e/iI+GTjQ6H8RbmY6KffxQ0GnRmeVYXkHRyPMuqUIv7ysAH?=
 =?us-ascii?Q?gfOqwHbINsCDjuI8wjO6IScrjg/eP22gLDlLtuG4d7D17F7mZ33+kAl5pekx?=
 =?us-ascii?Q?hxpIw80pTVHFatCyk3mgcu3QAdJ47JndocJDZ2CI/r86X3ZgJFOUI2IWI0yF?=
 =?us-ascii?Q?trjqYBxsUVcSVRVc9BM8c6cChfbCsTWcsIJCEOs451987KcY704v7LYdD1w8?=
 =?us-ascii?Q?36oq12ZkYuZSiMC6wvFnUwquotj5FiSqYEDcCo3gT7TNxke4tCO/ZSzA4cVi?=
 =?us-ascii?Q?uLMqkj6d2yT8C/Y27nvJ1a6fXUXc3mlnpVXbZyar/EeVkfnTdDAIYtTKp2Nb?=
 =?us-ascii?Q?X3XnQ8GLlS13Eer+9/QqZYG3UGDRFvIX2PV1yaa3zRXjXzghuzGqAA6aNQHL?=
 =?us-ascii?Q?/djPMsys0fKPQT5dBfbS8Wr+utZyLvzdBtHN+SJT9PDiHA15JK688QsEuaXl?=
 =?us-ascii?Q?79F1QB9+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e87fe1-b055-4018-f220-08d8c96b8c20
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 00:18:22.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYflqb6WsWS2e4lTaNif6Gtp0aesndTs6qcxYbbCT27pqN38XrdTXDx8ElR40pCe8HVbsB/jQrdTCdrq4XVO6XSbl5GFvP+yT+OuwL920iY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=666 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=846
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040148
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	i) Patch# 1 from v1 has been removed since Paolo has already applied it.

	ii) Patch# 2 from v1 has been removed since we don't need the helpers.
	    The test now uses the 'prepare_gif_clear' callback in order to set
	    host RFLAGS.TF. The test also triggers a #UD on the VMRUN
	    instruction in order to find out its RIP which is then used by the
	    #DB handler as the begginning of the sub-test that tests Single-
	    Stepping right on VMRUN.


[PATCH 1/1 v2] nSVM: Test effect of host RFLAGS.TF on VMRUN

 x86/svm_tests.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test effect of host RFLAGS.TF on VMRUN

