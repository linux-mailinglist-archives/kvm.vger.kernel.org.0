Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B6411300
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhITKkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:40:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32024 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235968AbhITKkJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:40:09 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KAOUVi018022;
        Mon, 20 Sep 2021 10:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wRwqay7ePBpqK40KF/hvYgmQ0kn+OTwxHDIO7fVzWB0=;
 b=eyfYw5LjM9NTzpa7gm/MYjMx6SFZNAecjEh6e1+fPp2xUKQuU73kBak4sA6kQp2V+R1+
 KpQhQ78em7YwlUkYed4HzXyb+ZT8vsJM1VwhrmH5xDO2drMKjiwhPTYMaeJQZxLUs7yR
 6RKCYITVW1ByWFS8Bvok+8p4TSWeb3utzOMB9DdMRKFuJwWep9ImJ/hLckqGpPw93Hbw
 p9Z6y0ZmT1TfZxD7dSFwniuU27khbhRVLmEX9lgHDQz5FRmsuqXSAsy7t+Rt9P712fXU
 gi+SAREaye/WCgcmMqGwHsnNnMRqYaVLQjr1QfiLV83pJOb4Yi20c27rP6uC+V40Jmqe Cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wRwqay7ePBpqK40KF/hvYgmQ0kn+OTwxHDIO7fVzWB0=;
 b=dVVAF2J8/QDcqd/8JKW0Ji7j4c56SFtlLIgLGc0uZanTpxvbDyWyuk+NHJTq6MvbXDwL
 lTl7VuuZVYlZKhXSVaxMUmitBf06Qke2XfLwxG42po1lyYglXiSeTLq6zMP9RcZqUTzV
 kLTl0mtkUAC75tKoGmJ5jGLMoS9251gmlFuMTuBfNGNqh89TWjCEzPjCJ7Ekq9sqgy3E
 VAj77iI7I3YnQjNbjPaie7vqJ/i1s2I9mnQVllO/jL4Rb9wDc0U3uwK8jaTIj++aLWl2
 HW8uxgfAj936qSwEXy6ziT136KIIMKtx3UzZ6Kisd/X4E043KtVxDkSOdYDKn09TaYTz 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66gn1tm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAVTOq106020;
        Mon, 20 Sep 2021 10:37:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3b557vbvc6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlX1i+++SsHxym2Nn9x1s01KWKoD3KZbcf54QRDjgiv6I2+tE3o6CUAqpNriQc8WZXWrfisl6ntDvfzSbGKDL2Abxz4+ScDwQoVRSnbmr88XbVpNZjZQ1yAKebc2aFpsjKX84BGYGjojJHuZI7BCT3O4CZE9AsBtK9G0tBgGEw0RzTc60K3UzQsuP29PWhlmILKSWJUNCIJj4ghFpe/EAP63LGRrRVAKt13uaNUIBwFahMLsvI7Yexv0mDv0I7Eu1y8OJ3+6ESuwDLEpASepxVo8kC1Fl3uefnXN4VCB2P3eGejsqBIfyf5PrNjztWrYqeKlpJAfttt09sa+gwwXQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wRwqay7ePBpqK40KF/hvYgmQ0kn+OTwxHDIO7fVzWB0=;
 b=b8DRTcEWHws5uQPf7P1n9uLAOye/G+S/qpPglSFm/ugGAIvWOKtsayFCpGR80NwT+ebkfse9mV3YMGHqXErx6XCf+6YuSSWP53/c9rY2RR+aEIOHLD/pHpFVxU3sQbXnnW9YasQQMW05tJCFDHkJnNZy9b82r8F8ctBflubxwCLdUh54bzrWWhVhccjQAYu17aDBiN7jfpPfInq1ZPN4OGV77d1t0NbsQSsQbdjShXR4JycmJZMLs9bO1u/sLqVYjpgwrq5d6V/8M/NTauSsQoV5AMBOTyUiukGnDzCi/V3ceMVxInt7sIvbIFkr9R+GvwCd+miCjfil2QSzjn+5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRwqay7ePBpqK40KF/hvYgmQ0kn+OTwxHDIO7fVzWB0=;
 b=LN/yvylGEdn4y76NgWxGVkrnGRGS64F5SePrfvwoiKT3i3ntL1LUduerkkCB9IHsVOomKSKLWKMZMxmyDsNrPSPGR03LazYzjO2mEDMDjt8qVVQMOqJucSLfczQwFReXn7iUwxq02LRiK9+mJKDKtyrUUOLkTPUnXyntEaz5TU4=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3308.namprd10.prod.outlook.com (2603:10b6:5:1ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:37:47 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:37:47 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v6 3/4] KVM: x86: On emulation failure, convey the exit reason, etc. to userspace
Date:   Mon, 20 Sep 2021 11:37:36 +0100
Message-Id: <20210920103737.2696756-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920103737.2696756-1-david.edmondson@oracle.com>
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::24) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 10:37:45 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ca669824;      Mon, 20 Sep 2021 10:37:38 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56cf57c0-1ac7-4b93-0fad-08d97c22b009
X-MS-TrafficTypeDiagnostic: DM6PR10MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB33085B98F88C2062CD23AD2988A09@DM6PR10MB3308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEnW14fpaghJkloMGB2jHP+VCueA8BnB4pKJwcjaDmLwtv/0Hb1g606wyeoZ5Bmf/87k5V7UeI1rsA8x39s2OswyoZLk8P1FWuES9dcnkWUKgaIjgfOK8384nDJmroAJu6kQf98Xzd8yHXuAIY2g9I3O1Z5Kkp6ylziIdoOP6EUJMilmQQaG/2nRf02HB7Z+eFz1yop0Mo0LFac9h4x91lRlFVOppW64htVlZQdL27XaTK4wbubpQSNSgrLkF3JsIi8sj9hCQgxBYf8gTiqVBAQsAvu5j4p6d/ChkGgRGEngtNR12V/rVdJkx96hV/B7VcXmYsG9w7fzO/0/KdIEeyuRsYyN1crogkjYuKGIHaY8vqjTi+9gPXs5QMDotB11OBy+vPswnyN4nhXqfVCMrJR2MQpRIrwIlqanYmr10PpEKNt0hSqrrvJGoGhpf+2CWdH4q8ynXHqgYvWuYF/ZxeyH5yOT+A8k01SIDUuqxAq0Ju/yqIKA6cejqB4bf74qLzZEugtS5J1ieQSI3erCY+9p9uWQ/2E6/b5AsdOCtstu8Ly3b36UK99lEJ3VIy592lsx3VuYX41W1XT2bPjIvCs0/u2rOFSrIKXjg80BdjFgloONHTmK+L7qWAD74ZDfOZSETxJmrgW038G+H056TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(44832011)(36756003)(107886003)(1076003)(8936002)(7416002)(8676002)(83380400001)(186003)(4326008)(52116002)(5660300002)(6916009)(66476007)(66556008)(2906002)(2616005)(316002)(38100700002)(54906003)(86362001)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CkURCeXLVrOwsCdzgRYKHjwDFhu6wFdjbGIUoYjDwTzKkCgnH8oYYl3HvQrh?=
 =?us-ascii?Q?amlgk5ix6bqNwG3aek+0HuhbPA5Lxno4NymwoHbada5waCGCYRQqhYPwsUW7?=
 =?us-ascii?Q?fjNByhK4sMLsP9nO9y28ERCrX7Fg0f/9/+40YyLetzCOQ3xQY/vxLPX8Nctt?=
 =?us-ascii?Q?ftK1TL9Z3MoPaFVgVKRRRGUQ+lDVpm8DB5l0c+yEn/OMRHvmO9Uh1Wkx7BFe?=
 =?us-ascii?Q?iA8l9F/f2eGOBTb4H8UasDmYRG/wxWNkoMpDD8t1V7IjtQJCT+Hc/+F8YWjO?=
 =?us-ascii?Q?pwcz/LSAAE7IbIx94iwr7KB9DH+l8FOVt6O35ZTyEBAonzLGEEfl3FBkrw1V?=
 =?us-ascii?Q?NIdRn7vXeJgTLSJbJ7e/TOt0MkbHQnwQEL08Yog4gWgbTMUJnYuEEiwwXeNX?=
 =?us-ascii?Q?YD0ctw9MPM17g0XiIay+rt/h5Otv2hIHBlvlzKb/BiHmReWW74frtj8qjvD6?=
 =?us-ascii?Q?kkJ3AQDqRfScgt1kFFpwn8mmH8EKKkraicj3TnpidbXG+N1X/gILv/ROzc8o?=
 =?us-ascii?Q?OjkkUq+qcy8nhoBPb8xmSZ4HXuxfLHOtnJM3j/EXMQiopruv+nsx3nU4oY6v?=
 =?us-ascii?Q?OoX5FQTiN0aB49lLy02cXFwG1ST8UUHzTU9H1BGHHQsqarHM843tlLA7axlC?=
 =?us-ascii?Q?XgHodWiietPwTMTNVpAEwMEhvzV8VQNL8jR5jBAkg1zx60UxyFgbc3VNiVC0?=
 =?us-ascii?Q?6cXcG5s9vs2DyTDP8rCef6RUfbcocSiRKuoUQOxQiRjINLfHIdc4teT4Sezk?=
 =?us-ascii?Q?P2bJ3B6nPSZNtzTf4BisfpsDL1tWFoiOBtB1DTZf6RSq7cuMOUG4pRVudRgi?=
 =?us-ascii?Q?IqfQmb16+RAJoaHN/o45J+/eF9C7f8BdNJ+uX6AM+AJECw21MQwryUAZ0RCT?=
 =?us-ascii?Q?NJM3mfHwgx+xd92kB01xJKXZQgUL2aRm7HZEvCdPxVvL5Jkib36QTWkH2dWD?=
 =?us-ascii?Q?epfW0KXT/T59H8XATtJt7dxATaQTySoVuwLW5uED2D3UtOGiAy+7GPh+CMdp?=
 =?us-ascii?Q?Njztu3iUGnluEdm1BENPbOraXTQIP7oDs0KWV/T8a0YVUmQ4SX8Hu+Svwh01?=
 =?us-ascii?Q?LmHIjC6voMzR0Nap4vf9mEodHbZIhxH4qPtMiBlJyaU5RjmHM03ff7q+qof+?=
 =?us-ascii?Q?Y+FBsIR/rjqupO/jex03oWMlGLSq8g5Te1aSWDToIUnFpNAiemrVtzQZVhlI?=
 =?us-ascii?Q?6BDe8sVrJusEVERXvVlyt4OQBCwDRj3lBH2y20Tzi2DV1SLPncoz+6yLsi+A?=
 =?us-ascii?Q?d2G6AD3ySVn/hDVjGE89rleDaKCh1epskkD8uA3xeqRIyhias+F1dgZ1vc/n?=
 =?us-ascii?Q?Q/BtrxmiIH+DxGtIx0sTJYexEBDlOZIAz7ezNTXSXkm+7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56cf57c0-1ac7-4b93-0fad-08d97c22b009
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:37:47.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzWRAXIOe4xie2M8Cus0/44Pp4+JivA5Dhysy6oXnWGEKYRU5LteewKSL+JawcDAtgvFV2gR1wK++WncgJv2B2HNzOLI8eCzH4BxXEjrwhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3308
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=828 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200064
X-Proofpoint-GUID: VEvZvCFCFwESt0Prwq6nlAQBQ0v9hBjc
X-Proofpoint-ORIG-GUID: VEvZvCFCFwESt0Prwq6nlAQBQ0v9hBjc
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should instruction emulation fail, include the VM exit reason, etc. in
the emulation_failure data passed to userspace, in order that the VMM
can report it as a debugging aid when describing the failure.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/vmx.c          |  5 +--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        |  6 +++
 4 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d22bbeb48f66..297581046460 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1658,6 +1658,9 @@ extern u64 kvm_mce_cap_supported;
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					  u64 *data, u8 ndata);
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99f8f7c4a510..e71f6ccafa5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5378,10 +5378,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-						KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..55fe3203a3c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7468,29 +7468,78 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					   u8 ndata, u8 *insn_bytes, u8 insn_size)
 {
-	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
-	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct kvm_run *run = vcpu->run;
+	u64 info[5];
+	u8 info_start;
+
+	/*
+	 * Zero the whole array used to retrieve the exit info, as casting to
+	 * u32 for select entries will leave some chunks uninitialized.
+	 */
+	memset(&info, 0, sizeof(info));
+
+	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
+					   &info[2], (u32 *)&info[3],
+					   (u32 *)&info[4]);
 
 	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	run->emulation_failure.ndata = 0;
+
+	/*
+	 * There's currently space for 13 entries, but 5 are used for the exit
+	 * reason and info.  Restrict to 4 to reduce the maintenance burden
+	 * when expanding kvm_run.emulation_failure in the future.
+	 */
+	if (WARN_ON_ONCE(ndata > 4))
+		ndata = 4;
+
+	/* Always include the flags as a 'data' entry. */
+	info_start = 1;
 	run->emulation_failure.flags = 0;
 
 	if (insn_size) {
-		run->emulation_failure.ndata = 3;
+		BUILD_BUG_ON((sizeof(run->emulation_failure.insn_size) +
+			      sizeof(run->emulation_failure.insn_bytes) != 16));
+		info_start += 2;
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
 		run->emulation_failure.insn_size = insn_size;
 		memset(run->emulation_failure.insn_bytes, 0x90,
 		       sizeof(run->emulation_failure.insn_bytes));
-		memcpy(run->emulation_failure.insn_bytes,
-		       ctxt->fetch.data, insn_size);
+		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
 	}
+
+	memcpy(&run->internal.data[info_start], info, sizeof(info));
+	memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
+	       ndata * sizeof(data[0]));
+
+	run->emulation_failure.ndata = info_start + ARRAY_SIZE(info) + ndata;
 }
 
+static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
+				       ctxt->fetch.end - ctxt->fetch.data);
+}
+
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					  u8 ndata)
+{
+	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
+
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -7505,16 +7554,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -12153,9 +12200,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 	 * doesn't seem to be a real use-case behind such requests, just return
 	 * KVM_EXIT_INTERNAL_ERROR for now.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	kvm_prepare_emulation_failure_exit(vcpu);
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8618fe973215..cb032a95aca2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -397,6 +397,11 @@ struct kvm_run {
 		 * "ndata" is correct, that new fields are enumerated in "flags",
 		 * and that each flag enumerates fields that are 64-bit aligned
 		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 *
+		 * Space beyond the defined fields may be used to store arbitrary
+		 * debug information relating to the emulation failure. It is
+		 * accounted for in "ndata" but the format is unspecified and is
+		 * not represented in "flags". Any such information is *not* ABI!
 		 */
 		struct {
 			__u32 suberror;
@@ -408,6 +413,7 @@ struct kvm_run {
 					__u8  insn_bytes[15];
 				};
 			};
+			/* Arbitrary debug data may follow. */
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.33.0

