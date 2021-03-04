Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E93F32D891
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 18:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbhCDRZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 12:25:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhCDRZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 12:25:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124HJn0l047619;
        Thu, 4 Mar 2021 17:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=5Nu8LhZmcqUCQJ0qZGI+v6GHG+uZ/d+7ONyIZ/jg7vo=;
 b=wRYwNoXue5bWP2vzw8PAvdcIWAfzdN53YhIQsInMptAXBPgyATMdhytlngFZXPka76/V
 wdILjz/3+heYfx27T2fVL9DWIK0sAGe9nqrymRi/PPdSzmB697p4BTI0ueFhh/+tVKCC
 03IuzFTN635D2XC+bRDIZ93xhrdvL9T4wgsbXQX2I7PJ1wxNXB9Jp+I/yQnJucYR+It+
 mt9vW/0N7hpKMEgTOe+8ot0/eq16Nt0egquYWlPaBbtbUw8lglpVuZywFNvG7kTvaP6K
 1+jafVcEL0H55uEU7AQp4uKIgWaSpGiexkgG5O/2+ty8d1YvFgLTLZVrNiHEsOOEDpXj lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkbfyek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 17:24:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124HL8JD156527;
        Thu, 4 Mar 2021 17:24:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3030.oracle.com with ESMTP id 37001143c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 17:24:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUQNzSI47m3mQlH1EsKa4rZy1PxRWlYfoP+hdj1EyYVwwCJUdx6+bRtOBb0wt9TuUOjF4PuQOi4VAoIkGquHv/bxrfU5ZamssD8Q1v+zBgFWdNUiMQWB7Rrdsjo7zVZ5hQ5iUbgFVSgDj09D44y5qiAIsy/2NBg7+8Ce4QSfPn8eZnZGXgvGOA6H4+hhz+l08HCejZu/dztpI0DvptdpAO+UNEph/tAKxw3RZsySHIqY9Sxr6FMqk3PufcMzmDAhUUngune22QlA2DZKfRoSCJGpGojEt0Ml1eKvtK97JXE6IsmGzO/2IfwpDwTPlYdpxDOBrXhLcWnCISkzRGbS5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nu8LhZmcqUCQJ0qZGI+v6GHG+uZ/d+7ONyIZ/jg7vo=;
 b=VeShu0/Bxt05d8OEBIEy0na5RYiBf2oQjtnF79Ln78jRlbPK/2g1dxyzczGPpu3dIIb70WERrFoTXaHPTzWU7WBaEoMmin3H3GHhC4m1epaGtDDFf9svs/G2GuxcCQlMOoR6IaJOgbKWEl8Be0Lix1nP6w1bqW7jIGhvggkHEE9OkPpexxXSF1zwqKjjt2cf5DDoSBSAtHi3smX4bv/ewz1GEkoQq70Woc0iaJWJonFkkndqv0xHW01I+IPy+TJTtlMtgxpTEcfxnSa0DwrsVe9VkyzQAPlRxOr1pZPgJm90ITWRXEG5E+vmX0Oei1Dej0bEf9iNgaJhggAMWx8sWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nu8LhZmcqUCQJ0qZGI+v6GHG+uZ/d+7ONyIZ/jg7vo=;
 b=XnZKUVPrc0HKmoDG0tZ4XZwQ3dKFsoC7PS1OLFF8FJuy+7/1ERCW2w06jlZL6zb06QTYHlzMSF0iAB6QOxXZWR6vdqIxPtEhjLVs9fADaZt1MAYH1vUB/79/IJjnEi1GH6SbjcGtmQ5as18URMu49F5u40qOJNy210jigzGe9L0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 4 Mar
 2021 17:24:35 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3912.017; Thu, 4 Mar 2021
 17:24:34 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH] nSVM: Test VMLOAD/VMSAVE intercepts
Date:   Thu,  4 Mar 2021 11:36:12 -0500
Message-Id: <20210304163613.42116-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: CY4PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:903:77::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by CY4PR06CA0025.namprd06.prod.outlook.com (2603:10b6:903:77::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 17:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06c1e1ac-a9aa-42b0-02b7-08d8df326143
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4682207EE7CBAED8472699CA81979@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LbfRnty4HQdnQZCPUrOABGBUtFvsPD+WhHU5IxzrHvvaFbFDHL6zM1dIwsTp6HLn0rSKpv+KGLeqR9fIcgmcfl1ikxXP+94oS/Ez3RluCzLWBxJDmugiV8C4CUeOy2E49uWwVo4BiUIYb6Ut0oRJPBfzYPa1XnOkiwxRMTNtQq1JPmGopklt9eqa0SlFFFMuCYs65kzwW+3/+4cbO3StckehmWp5NEv/s3oggL757+JwVMJqOttXYSwXNYm5oxMMeJJ0hbXm9kf3Yt6L8VzXEZFqBzw42dB37/pxAyG/WagHAzKMssQcmX9QtVMSQGrja4DJm7txgHRqFpbzXIgeSfiVVGW+wvC/F1wRizGID+POEFxV85XP6qIMKPGcvT+dA0R9qFvoH3Yt+7dEufAKGJu/xaeKD+ulc2o6E37E9lApK5e6aEW5PiNsfseQUb3Ynwq8bUA2PXxykhVgday5q9jyo/fsmy273rU0rSyICxJUYuS8+HXZPVQYGJ4S+d0Btl3TrL3kNSWrJF9rlVgVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(6916009)(186003)(83380400001)(316002)(36756003)(4326008)(8936002)(1076003)(16526019)(4744005)(2906002)(5660300002)(26005)(44832011)(86362001)(6666004)(956004)(478600001)(52116002)(8676002)(7696005)(2616005)(66476007)(6486002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cAW0Io8E4nwlw6h4zBkDa/uSQvDpk2tmnTCSQwsVY9aTIIIGUsKko1wuNZHx?=
 =?us-ascii?Q?/wJrUxNr1OfTH8naM2x3i/LUIgpfpARgPO5swT6aYsOvk/lbNPSsnVIYJRWX?=
 =?us-ascii?Q?nNIymOH65ajPCLBX8ouB+NiJg3AoSM16B6+2s0Yz25mamkyj2Cyw5WVZIhpp?=
 =?us-ascii?Q?kVS4YKYCfkrx16AVqS4F1kqDD7Iyp3gVYCY9UUTkraoBZ1qtqbQkkpriI1BT?=
 =?us-ascii?Q?KxWG0N38A/iNTebKW8WBNZVQ5KxwdFAie5btxa5lMPBO7RRFdQZ0PgKs4Wfw?=
 =?us-ascii?Q?hpNIolI11Oqem80+DmskD3sJToCFwG4FVp/BO+KVohxosRgsNcY2276vxIn9?=
 =?us-ascii?Q?I/A7lRzk9T9r0tkVf4mR3PCKDvvxUM9oHZrPqShiLtLS+4aioNPwG40KUPUd?=
 =?us-ascii?Q?044HCYLHaSzB3/8EYHFSzYEzDYISv2s4hY2qNN8Dk6ECV8AYhk1XqrYPIrjF?=
 =?us-ascii?Q?EC5w+tnTsdqCLQ/ohwR9EsOVoISbz3bWKLkaiqHIu8XMbIqGvwRVrgJ6v0e4?=
 =?us-ascii?Q?OgM+6W1KqEA3FM2ns+AxKRnYjbTLrSEFu/kgLUXN6wskptSnEOc+YcCwhMXi?=
 =?us-ascii?Q?JWOaTf8Mko+Wi93X+2KchM15V4SeHVCP7Lxz316P1JpuQ10VcnP419LbF3gn?=
 =?us-ascii?Q?OtdUi3WRgfC2AI/RC/pVNDBRVQdsAqi4UMPBUYVhTlBcVbk0l8a+Z2gO2xWq?=
 =?us-ascii?Q?awXX6loWp5sEoInQkH9bJ6mXOBeN8171I+R3F76xYVTaXBRYCDS7JHX+6nyB?=
 =?us-ascii?Q?vskUYSqbSpa7m4MEJHKscgJSxA4PgumlP//0R4J19sImvgo7hWhQ8gQ3w6Ll?=
 =?us-ascii?Q?0fDCjz1pdWUQXOAjqB/OxGYYbPnlwzCegRsrSYC00YGxkSC1BUnvOOE7LdXZ?=
 =?us-ascii?Q?bbyWjCPgKRzChTKTNH3Tq54l55kLOvefyTdaUDxzB10ZgY7lrP8IvYe2CjnP?=
 =?us-ascii?Q?xpNKk4rz/NA9bDt6wJI3bgTR5olYJEGvX6QTqxE5QklmnEggiGcL7Ef+brU2?=
 =?us-ascii?Q?2MFgVfkoDTU5YXucYfBCeO5CN3BhcsFKVeoy2CJDoLV8Sy6QOxqBKGjSEHrR?=
 =?us-ascii?Q?UbuBLjIcXdVAkMQhAP+QYzcQYcpgl+aeqZke+8oQ3WM9xBwTfa07lhNOJ41H?=
 =?us-ascii?Q?PqI434qZiyK9xELgIFPntAiQdJ3mwXilYJcL+j1Ie1KvM60mYV673blIgXZ5?=
 =?us-ascii?Q?C3y+3YDOGUlgt7qFvCuBR0R+3+eZBZEV+eRZJN+OxwbaBAgZ8MXN7IB59/h4?=
 =?us-ascii?Q?axn5MAm5KCLNOPhvVH499MJzFCb87PERQ2F0mfQvMSdLLHHieIAgUC95hVXI?=
 =?us-ascii?Q?6sRKD8ZFIVgg/ze50r5W0OWa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c1e1ac-a9aa-42b0-02b7-08d8df326143
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 17:24:34.8913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVsRz5AnHSJBmxBHOSD7HB/kV4Y5kDnmJrM3hSZ9SEu6MqpSUfLb2b8dSGn/7gvyMdiUyVxd9heeyHdbvWQPQQcoY0q5DnFmYqJzbxv+v+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9913 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=596 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9913 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=779 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If VMLOAD/VMSAVE intercepts are disabled, no respective #VMEXIT to host
happens. Enabling VMLOAD/VMSAVE intercept will cause respective #VMEXIT
to host.

[PATCH] nSVM: Test VMLOAD/VMSAVE intercepts

 x86/svm_tests.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test VMLOAD/VMSAVE intercepts

