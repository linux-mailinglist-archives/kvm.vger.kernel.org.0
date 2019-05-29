Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA572E93E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 01:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfE2XZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 19:25:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfE2XYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 19:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Kn5wMqWy3JTU4pX5ypphe5EsBomce7cXwt2fz91hoN0=; b=GOIrKYFnz8bubQ1Qmo+Xfh4G3i
        XpoOuYZYAJHaRhwPaSLZLDanj/a0yRVt1XpoTL6k1inyUu4XbIMo28E3nGykAF/1btwSDBousVY13
        1dgmxiqvL7L+yUYR1k2fGmsEdHVBh31xcpKBXQEcWdp4NPTrRjuHQVjEpjBCDGEExpX4l1/+SNOxK
        YKXhbORECPHiODD9m9KGdBn9DlkHP9nHdFwryrue76j5rvY+Yy23VE2BZM5XoP6mhYBiNcbWERxUe
        hSOC435+IKMttTqWMyUZx620sih4ge+EVcQdKQK9Y9vhYGGRJU49LJ/uiDaRnziTQ6o4zjypW+p8Q
        i21s2msw==;
Received: from 177.132.232.81.dynamic.adsl.gvt.net.br ([177.132.232.81] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hW7vL-0005Rf-4n; Wed, 29 May 2019 23:23:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hW7vI-0007xM-OL; Wed, 29 May 2019 20:23:56 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 10/22] docs: amd-memory-encryption.rst get rid of warnings
Date:   Wed, 29 May 2019 20:23:41 -0300
Message-Id: <76b7a2990edd771aa1708862d0c6644a6b2d795d.1559171394.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559171394.git.mchehab+samsung@kernel.org>
References: <cover.1559171394.git.mchehab+samsung@kernel.org>
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
---
 Documentation/virtual/kvm/amd-memory-encryption.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
index 33d697ab8a58..6c37ff9a0a3c 100644
--- a/Documentation/virtual/kvm/amd-memory-encryption.rst
+++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
@@ -243,6 +243,9 @@ Returns: 0 on success, -negative on error
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

