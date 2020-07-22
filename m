Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70618229CB0
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgGVQCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38024 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730293AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C91BD305D6AC;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B7CC2305FFB2;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 25/34] KVM: x86: svm: set .clear_page()
Date:   Wed, 22 Jul 2020 19:01:12 +0300
Message-Id: <20200722160121.9601-26-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5c2d4a0c3d31..1c78b913eb5d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4324,6 +4324,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.fault_gla = svm_fault_gla,
 	.spt_fault = svm_spt_fault,
 	.gpt_translation_fault = svm_gpt_translation_fault,
+	.clear_page = clear_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
