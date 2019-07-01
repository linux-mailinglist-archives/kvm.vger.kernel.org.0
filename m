Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5138E394E4
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfFGSyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 14:54:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730969AbfFGSyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 14:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NXx6PmnhUtUTm/ybGqV0WKQy6usM3ULP72To5/hYtqI=; b=G6awMd3Pb/sgDUCaFMGFadoXXC
        FZIN/fwRwa6G71lnq01psWhTZk0HEZfYjNFQPkoRfopv5oOjk/80akMAR0l6VZyGzWE9kQnFBXBLu
        /nxC2FlmRAe+tCtWLHrCvPepe4jtFysQ6aPKzwVDTRyvyF5Imy1YgF5py3pO1mTKHLNBA0Sfdn84p
        lZAwzuS4FYkrnquHBo8j0QOxJicw2MSWgNu8Sgu/7DnZpm64mRVG5lAgj6bO1MLT6h9Z8M6n8nzhc
        RKKLO4Q7XIAorOZqEnp3lv7VY6H390B7KlQkuVIcTQAYt972yDSJPuEjT8GIvWZZd8wDQ1v3eJZQV
        GxAV0n1g==;
Received: from [179.181.119.115] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZK0d-0005sZ-Ji; Fri, 07 Jun 2019 18:54:39 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hZK0b-0007Eq-CG; Fri, 07 Jun 2019 15:54:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v3 07/20] docs: amd-memory-encryption.rst get rid of warnings
Date:   Fri,  7 Jun 2019 15:54:23 -0300
Message-Id: <53b10d30d1341e4d4b6cbe8e49f96afe15e54693.1559933665.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
References: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
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

