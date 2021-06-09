Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995303A09CF
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhFICMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:12:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbhFICMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:12:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590v8eg186036;
        Wed, 9 Jun 2021 02:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=5Pk47gi1k3BCEE1sILrxJq9/89K9oqNN6M3Y9QP8cQI=;
 b=t7STP17PHEwicomfv3nQsluSXxSeXy8xZRKLPTqyoQeY6VvmjZot1ykigTCztqWrRTY6
 TD6Tn5iovw2A5+S4VqEwwylrR4Ext96tvUL7K4GcX83qJTSqfFylxQRVFsaMNlTgETae
 vzfOwJr/G4WfSsiSEy0LSyu5waVASmwMkzfenk7wU3dYsb4lyaVOg79i9rshEwuOe4IJ
 CZJFJtShhaQYWy9McVunQ9H0zMJCbUoj97OhL5dDhWHjuggUu/wPt9kJ1fkJhzuUdFl/
 /SywsEtkfldEwzZPqov7bM8m25ywj/e/Fo/fLHeDc01NH0kofJZsoaN7Qqdt+TWR+GBh BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3914qup5ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590aNcm129799;
        Wed, 9 Jun 2021 02:09:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 38yxcv89a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNw3GMjtqccG4DnuLyR7wo0I25CvuZjLw4DhY0Gh1NEc0m++YTb6DAYUqnmzCXkzM4T0T4dsY8SrkneuCRzdyjnk1FGn+EC9f1aNEmeHCZ77tmTd3nI1creJCKRVgmuBCJ1KFaCY5IlZ9Ch5UgplUUZU3wbm7bRUl79wF0WImpstxmraf122pB/rhCtLwxPKEk06JBiAssyAmlk3zAgPUCi7I6vYUC672Tx6y/oak3wxvGQB2H+KCdljVBZRYbo48r8wfK3soqBPvLl8Rk2S6yCc/iuUQ+PlIkEv1g/stzcZDufqXPQfUMlYYiJwETLlWAHNytFLt1S2RivlXqAo2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Pk47gi1k3BCEE1sILrxJq9/89K9oqNN6M3Y9QP8cQI=;
 b=WRFtJ1G9KrKA/mh41Jb3Rr+c1xBMe2PUrwZbVui/ATbX5kPM+XV+5uQxx0TwnTUycBWP5EN8Ip6zjtXQrMNv/OTpSABlXwpp5FhXcDYu2KukoXuY5bXC7GyOHhvCUDID2BwxjKuKYBM+HHMnyUIGL8gWD2xE6MpwTDSCaI+GWVwhmEgYiNcg7VKsrS6ihBL3nsZEVxjQKSk7hYdNY8Y6rkz4sDRC/L5lJjJFlFkrsjlcIxH1aYE9nsMvpqp4igeSdobkK3CCMch42/rHWxUcjNo9klJc3fZQ6Z63om5drury412WzymBbgX78ZST6NDoPiRUR4ejP6igwHGjearG5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Pk47gi1k3BCEE1sILrxJq9/89K9oqNN6M3Y9QP8cQI=;
 b=gn1xgwSSpeUABXxpQ7B+wsZHPis4gig4Tqg1lDksOOJIZVXqf653G/5zvXCrGZG6CKS0p738pfOv6Au0LGiDZAHkhrFKYO0neEmrTL9kNtXRu+pMqfe4++2zUSiJOpgMeV4Vi9/UIjPqfMJHnvfKa6DXnaPvuQAWnrRUQIPMqec=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 02:09:05 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 02:09:05 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/3 v3] KVM: nVMX: nSVM: Add more statistics to KVM debugfs 
Date:   Tue,  8 Jun 2021 21:19:32 -0400
Message-Id: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 02:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 355c8e35-7700-4a7a-70f5-08d92aeb8ea9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4524:
X-Microsoft-Antispam-PRVS: <SA2PR10MB452444FE094875714525D13F81369@SA2PR10MB4524.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77BiU9oEDl4wwfj2bIdo8NujiRUcUVk+hIsOO8G4JP9w6C0vbMJwzhqiajR8yOjllwyr8/tQFpFpZ6dO1sIfXfjCAkNMN6D233B9L3M4UEt+7+ciguU+mFjxG9byCPcll7LyjAWORLYbosJVEyciBk/s/VboEp8UdghlDwyeQOK8RqF7gJ4ZJTTHl7RpN4MUjb/4uNy6l2his6eAaI4saL37MBABSib+iW/dPww22xgjLGEpr1KkcbkNENW6VG4GKVzndI6FvqxKWZfZ8XPu07Q7wam3l7MTsW5v/Dz71K0dpQTtYSQ+0VzQcbh3/tjzQK9b3fPm6eHGBDqUPmEGh7DSDIlLf1QXCuf5Jy8vp3/1v7Cmw0d0MFJHfjI0bgo7a/3FrcFqn0nCPcOnOlFSIkoCPlUCtPa4PeY8LE/sSOXrLjVAfDKibNTaV5UtoDHke6IwLUlmnKy9rn29O1MFL/DsRZxiVLQQhTUMGnNFRqiRGzvlq+OsH+58RC5vWuS5ttoC49yoipHx1lJepPg2I1Uw0gLG3mjyKvwc80Cy5K9h3pFcGcB2BXjUncjPloq2H8RVQjMhGc2WzgGChVo29fn09EMoeyuE1Wr3zOUYBAU+TBWga9lukKZEJrBk6DnoL/E6NFQWFXpB1VUJw73kgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(52116002)(38350700002)(16526019)(186003)(83380400001)(38100700002)(7696005)(478600001)(44832011)(1076003)(5660300002)(86362001)(66946007)(4326008)(36756003)(26005)(2616005)(66476007)(956004)(66556008)(8936002)(4743002)(2906002)(6916009)(316002)(8676002)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpHPw+J8r2gyiaz56tD8icZq/k+nA5bOmS+6R1YdVJQKI+rgrvOuOcxxfO4j?=
 =?us-ascii?Q?PibhqX1ZtBq2vKk9A+kWf87wSLwhwH+bFvwkZXlkU0htgpE1Hvby4W0Jf9El?=
 =?us-ascii?Q?Z2Q/skafT031NBRbdlLnwyFCPNe/bERbe4d5TwQkbk7Cav2JqhK/xMuMt6g+?=
 =?us-ascii?Q?uUIqCAWhhjW2ueGg5ZXb9jVXsabUFY1lO50nNy7j2Iop9o9d8x3hJygELt6u?=
 =?us-ascii?Q?AsTcQr7HxED0NyehTuphJdhNXpil3/eM7HpqFDbsuwLhfmDlm2nYHl+V6NnU?=
 =?us-ascii?Q?QfwBv+Z0x//TfCNCke1+k6aGlnQ9RYjA5HsxJyKJ4QOLWBUmEKd0BRdp83tG?=
 =?us-ascii?Q?u1sKOdVDrdka0eLx0fwMq64fTN6tijABHce3LMkWq8AhYHDkRoERkuZ9MVzB?=
 =?us-ascii?Q?uFxAZQeKCwXHHUmB5hTOZ3vpw2/dhTS1XsOfn69n3FDwRHp0oM15RxNlSnSz?=
 =?us-ascii?Q?K5bhL0keupH2dNPIzcZjS7LTKgrgqNAf/DV49qeDDSuhjLu1Jso57od+u/EC?=
 =?us-ascii?Q?zi0SCTKE8mNErHYw3Hgdt7b8mDpn9lzf75pat9f2E0aydEWLJOHHX+5KMfaQ?=
 =?us-ascii?Q?rS/uGoGibIPSgcphKceXGjkRiLfGWTAyEvOw+6WBuVs0VkHS/zpFcg5qyu7w?=
 =?us-ascii?Q?VSDXV4RUgyEQv/PkaFOT+KsF+ILsLhVbvM+ed8OgvCd2ySeQ6sYtZmed9EzE?=
 =?us-ascii?Q?qCpq5wWLqO4LkfEgQt4ApYRzjJW0TXwc1mHzyTiQYO5AKYo6WsXGSsdiZngG?=
 =?us-ascii?Q?yTH2rSf0rCpqfc+5uWwV18GJRajURx+gdt5vkHmy7TUvz4jcWilDAafTbFgt?=
 =?us-ascii?Q?e7HKXm5MoYDyuyWHkiZRuSjDe39C1Gaxx+hOJ6sPlI0GZIXLHR/TsOZE6C9B?=
 =?us-ascii?Q?NHfpjxpKwyxmfOQTS/roRMEHYL3yD4rsOQhSusFyF83rf2HJNL9OxxHktQqP?=
 =?us-ascii?Q?LQjrWQsXHiQ4JRueP3QuIWdTUY7i3h3a3HVgW1tzKWvNPKH99ZJDEutS8oTK?=
 =?us-ascii?Q?s/cJdeBtzXroIRi2mIJSKVLoTCXVH5ueakudl5p877Rd5uHccuS0CD+ygl2+?=
 =?us-ascii?Q?LR0k7meJgccpiSbOzk5uXJgAxscQOcxBC4ILTi5PUe6DqJYZPJiuLe2r05Eq?=
 =?us-ascii?Q?4pRNMEMGtKcRbK3MjLLBlSelx6rasBtfKDWm+UVdwO9ATupkjztSzLm0Ybnw?=
 =?us-ascii?Q?qoNR+kIcRqTi3PGQo7iblnlsf5x6BrU78iK4tEA/eprr2AhenScVp9Rr3SEo?=
 =?us-ascii?Q?eTc1EBrAJcyWSaPGagCHODHk+/WVBevisH9WlPKle0Tk+T/g0NypxmyjF884?=
 =?us-ascii?Q?AvVw8iFV4M6iFEoU10oBX9AV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355c8e35-7700-4a7a-70f5-08d92aeb8ea9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 02:09:05.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjCVpil0Tggp6e32oIrlVZGtIKhWvsRK2dzOd0CxtAthX3YM+1cdwq8b4FXgaGMnraHUT7+6NhNMu2/D+2EqLQz1BiiPfXhciLquw+N9iWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=808 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: 9OnU8bPCw5GPWWp_f98i3GxhE2beFUHp
X-Proofpoint-GUID: 9OnU8bPCw5GPWWp_f98i3GxhE2beFUHp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=986 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	* Patch "KVM: nVMX: Reset 'nested_run_pending' only in guest
	  mode" from v2 has been dropped.
	* Patch "KVM: nVMX: nSVM: Add a new debugfs statistic to show how
	  many VCPUs have run nested guests" from v2 has been reverted back
	  to what it was in v1 where the statistic tracks if the VCPU
	  is currently executing in guest mode. This modifiled patch is
	  patch# 2 in v3. The name of the statistic has been changed to
	  'guest_mode' to better reflect what it is for.
	* The name of the statistic in patch# 3 has been changed to 'vcpus'.

[PATCH 1/3 v3] KVM: nVMX: nSVM: 'nested_run' should count guest-entry
[PATCH 2/3 v3] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU
[PATCH 3/3 v3] KVM: x86: Add a new VM statistic to show number of VCPUs

 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  3 +++
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  6 ++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              |  4 +++-
 virt/kvm/kvm_main.c             |  2 ++
 9 files changed, 40 insertions(+), 7 deletions(-)

Krish Sadhukhan (3):
      KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
      KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
      KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM

