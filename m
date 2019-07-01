Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857C034A19
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 16:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfFDOTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 10:19:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfFDOSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 10:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NXx6PmnhUtUTm/ybGqV0WKQy6usM3ULP72To5/hYtqI=; b=hhBf5LG46k5k+tlTkgrDdgTk9s
        okl9la7n1x4PnoWk8QeEavzXjTZaCxWLoPU9MPEH6BMBEhTdezg9JgJLifi84w+ITFDVVepvlgHdJ
        +3gXP2f/T5HL+E1Fr2eK8qcTk0wRY7aZNdSl+oZE4ODiLUcZJPdF8VZT2ZBYg0KA7dFfe9uWHzKnn
        zY4EqvnO4WDNlNSaHt+QX8kmpzPZGFsarGscykbhEidJRMDKBCkEcHyM7xjjGK7YWgV3kPFLc9A2C
        qf/V0mcgqYCaEMZwDtFLm892SiAQ892RqQY8cBtqvcUqJBRWvFvuCBeLG1QtsXNLfUD3Hp2E2Tlwd
        4ivpsxAA==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Rk-VT; Tue, 04 Jun 2019 14:18:02 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002l3-M1; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v2 07/22] docs: amd-memory-encryption.rst get rid of warnings
Date:   Tue,  4 Jun 2019 11:17:41 -0300
Message-Id: <7b916c2b8d551aa06527f332e423e25254b23adc.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get rid of those warnings:

    Documentation/virtual/kvm/amd-memory-encryption.rst:244: WARNING: Citation [white-paper] is not referenced.
    Documentation/virtual/kvm/amd-memory-encryption.rst:246: WARNING: Citation [amd-apm] is not referenced.
    Documentation/virtual/kvm/amd-memory-encryption.rst:247: WARNING: Citation [kvm-forum] is not referenced.

For references that aren't mentioned at the text by adding an
explicit reference to them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/amd-memory-encryption.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
index 659bbc093b52..d18c97b4e140 100644
--- a/Documentation/virtual/kvm/amd-memory-encryption.rst
+++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
@@ -241,6 +241,9 @@ Returns: 0 on success, -negative on error
 References
 ==========
 
+
+See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
+
 .. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] http://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] http://support.amd.com/TechDocs/24593.pdf (section 15.34)
-- 
2.21.0

