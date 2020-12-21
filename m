Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8BF2DF74F
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLUAyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:54:55 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:46517 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgLUAyz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:54:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 536F2580413;
        Sun, 20 Dec 2020 19:53:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 20 Dec 2020 19:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=KWLNfn6cch3ST
        kJIn9ZITmEXeddtBMzmWKV1IAEIciA=; b=SIelJS4Fke3A/aeRfSeo5JZd7hpoo
        lGPByjwCuuxZZSdIaz5cO5929SskOcL0ukg0hPUgyWQuvuGqm7lg/ObLoHZbMvBY
        xfdkJ9zqRhXOIUPTAuf6YuZLXp+XMLtd/MzkCTM/B/sP58UI0XrIMJhtCjf6zTK1
        B3wv3LCN3BJOmT/6DdNQWM8QKAmKd/qfAj22xjk+6mCFiiVpNRcxq7NMK0Flo75v
        /U95VeXOXneGZw9zeDMnRpWH9bOwG8T+WARTQuGsFcr8AwjNr/DLejg2g/kIvLOH
        K80WrgvFTPeowZCv1YJifdyS6g955nYxkCC+2mG28cGMF7S6/XXSl3IHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=KWLNfn6cch3STkJIn9ZITmEXeddtBMzmWKV1IAEIciA=; b=TdJUcTr4
        tJAhXwVjbuSZj2bwRxiwq3vjLrSeGQJhBOxVsxauF1dRlQxau4X89dB8t+iVW8EO
        BrFTJevYoqc1S7HC0N9M2IsKxW+OFc8O4h4BeODsAqw2yEoPqPCri9RHE/mBvKgO
        23/XADnLaiLPa7OGVzWqsdRibjcgUetjU3yPx2cZlBwqov6eLwcC1xnlE9Vqc549
        4QPXmmOwJ4ENMshP2Kdyqrc4EpPrDM8Yeexw57Gsbb/dXXdLKOxlGLw78ipee+Mx
        VOi3EqRJzMpUx8djRCzGqsGelVw+2EjXXpqGPXsgyN2xyyF1inWWQayYouqj5hQp
        jMxdXVOz33Vz9w==
X-ME-Sender: <xms:HPLfXzE5WPIREl4Aa5KPmO_-btAmCMXTG6QfeDBm0U4zyAhYPwOa9Q>
    <xme:HPLfXwV8FPKLkeF6mTKWkSWrxC49-cOfhJfjRg-lP1-kUwsZiOyipOvcHelbv9GFh
    6XnEYVVIwk3onwT-8I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepjeeihffgteelkeelffdukedtheevudejvdegkeekjeefhffhhfet
    udetgfdtffeunecukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:HPLfX1KkIRxG_Ykal9Up_fkfsPPDCsoR2__lED_Wc8lmgbWB9o5OoA>
    <xmx:HPLfXxEPcBCBla-cwjKt1tjuKmsmar9qh9byjfQ3vMqfhBLPcOuTkw>
    <xmx:HPLfX5V0L4vcwQQKUFsxwoqBXyhdXYTQ-swo_GMvyrRCwhvTEr5pJg>
    <xmx:HfLfX6tYE8V6oc3zFe1YgpRfrG_5yKbEsaCX0mOD8S21Mg_REO-yJfo-rqAk8fkq>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E63A240057;
        Sun, 20 Dec 2020 19:53:41 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Alistair Francis <alistair@alistair23.me>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: [PATCH 2/9] configure: Add sys/timex.h to probe clk_adjtime
Date:   Mon, 21 Dec 2020 08:53:11 +0800
Message-Id: <20201221005318.11866-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is not a part of standard time.h. Glibc put it under
time.h however musl treat it as a sys timex extension.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index c228f7c21e..990f37e123 100755
--- a/configure
+++ b/configure
@@ -4374,6 +4374,7 @@ fi
 clock_adjtime=no
 cat > $TMPC <<EOF
 #include <time.h>
+#include <sys/timex.h>
 
 int main(void)
 {
-- 
2.29.2

