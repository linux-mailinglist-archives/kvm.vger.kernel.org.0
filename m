Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CD959A31
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF1MMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 08:12:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfF1MMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 08:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BRhHz3Zw8Cudo+QmQC79lXuaDoT+57RtewzsL6NN1jA=; b=RnhO1Y33qlk3+N8twDif0uUGKV
        hfM9jNrow1RIXLXTJGSHGwv2o8UT07u1QkJ9ROOanEeYXEC15ayTlvgxNzh2Y4tp3aOWt51EQswyv
        QJuQZ1ea8GxpR/YDlpX3SIHuzR/i7tIixU2GDIgDqdyHmG3urPlPb9y2GguLjzc7rv1UPbAyYhfVC
        Zh6WW/DAd6aKzNAZ/1RuZillWWpptj2Vjd6SUE/JPLf0cRGqBJz9/EkeDWTYT6ACiHuzXqWUIxNcI
        sfW0dmw5aYj73gGrBixatipnQCjuiYJvi1IfOwk1eX5eGEhutDprBwOXsiELSOpB/2eYWBwBq/quu
        VnaTGczw==;
Received: from [186.213.242.156] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgpk3-0005BX-Am; Fri, 28 Jun 2019 12:12:35 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hgpk0-0004zf-B8; Fri, 28 Jun 2019 09:12:32 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 6/9] docs: virtual: there are two orphan docs there
Date:   Fri, 28 Jun 2019 09:12:28 -0300
Message-Id: <9cbd8c9704ed264c133dc7bd310ede56d1e9c836.1561723736.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561723736.git.mchehab+samsung@kernel.org>
References: <cover.1561723736.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/virtual/kvm/amd-memory-encryption.rst | 2 ++
 Documentation/virtual/kvm/vcpu-requests.rst         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
index d18c97b4e140..6c37ff9a0a3c 100644
--- a/Documentation/virtual/kvm/amd-memory-encryption.rst
+++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 ======================================
 Secure Encrypted Virtualization (SEV)
 ======================================
diff --git a/Documentation/virtual/kvm/vcpu-requests.rst b/Documentation/virtual/kvm/vcpu-requests.rst
index 5feb3706a7ae..c1807a1b92e6 100644
--- a/Documentation/virtual/kvm/vcpu-requests.rst
+++ b/Documentation/virtual/kvm/vcpu-requests.rst
@@ -1,3 +1,5 @@
+:orphan:
+
 =================
 KVM VCPU Requests
 =================
-- 
2.21.0

