Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D292F9A03
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbhARGjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:39:39 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:57479 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730636AbhARGjf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:39:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 53B0E167A;
        Mon, 18 Jan 2021 01:38:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=JkDA4Wi2GI0B3
        bcDDU6/HuHDUW1caUijozfHO0X7odA=; b=Q2f63C4OvLf+Cic/HcnyLKb3GIU6n
        6JkVvAbnISPFBLJmqTJdPsntzLxIAIRu7tnVX661Ee9aUJ7tEYF0yYScMpHPuuT3
        gWpf+/VrJtKDFqPj459Rffq067mbK5/MDc5NYosp0sYlTHn21QqKnlnBgAeT9f6p
        g0NwnO2+b5Vu7xRWItwSG8+5gueF0xALnMdTbnngFDdJGznY0SvEu3GKnQLYRwQA
        TqtBsTB5Rws0rwFArRbt9XBqYozNr8RHPrmXublRcYfl2Rfx10v5Qlmd9DTQ9zrt
        YAVbUlq9v5KKn6/2+vdZ6FXMQiP0EMOA49V+jsIeRSsC/pbTEoksi0bow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JkDA4Wi2GI0B3bcDDU6/HuHDUW1caUijozfHO0X7odA=; b=PsIhX8CC
        RKPW5WVS7OnLCtCD1JoI026OW7rEzsL+F2E6QHadrxlUBunyW387gYeAw6Olrxx1
        FemT9C6kWu8FaxEL5eAOQth89mEiv9bF0XmvPSYgIqoXas4JbJt0iwXli3Jg9Ipm
        05FlyQRIYdXf/yDl61PsSqHYarQwdeugt76OEuFnCM8sIofYFr0R5+DQNki0ec0a
        lXnYabCnDbzMrQnnwgU07GQdmFhW+6ZjDyIGd9QSyLJvHWcXuHV01NNhg5WDr5TS
        dx1tAe5yhTWXwPEUIolfEOCNbR7mW5nVbKSkg232MWzTlKZ73xMXxvgOa2dTdExr
        gWJ4/lwaNAaNwQ==
X-ME-Sender: <xms:4iwFYDQpTlWEeiJgIe9hTFeiJ5cDoMSakyBOdRBDwQKMeMLmyCuGwQ>
    <xme:4iwFYExfMudvoI-3dFmx9hDlkAN_7hTMjvFKawqBoJlHNqfxttHk0PRQUxozntgaU
    nOkLwY--S7XwviKVG8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucfkphepudduiedrvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihg
    ohgrthdrtghomh
X-ME-Proxy: <xmx:4iwFYI0zgWu2O_l4Y7dcl-I3w48Yem2suJCZIB2qR4LYE1E1Z9pauQ>
    <xmx:4iwFYDANM-uBbpiR4KsbV4Om1xovQjBTQs1VBA8-thlIA5-gNbFyOQ>
    <xmx:4iwFYMiBGQcq69O9tnHOXLp1gt_8qNUJpTc8B_SjKhgXHKppv0JH5g>
    <xmx:4iwFYIxps6-GK580Z8dKBTLw3OfR4Ce4SJwhVLbqk2Wh16mPRTl2ZEe9UA4brLFj>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3E5424005C;
        Mon, 18 Jan 2021 01:38:20 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 1/9] configure: Add sys/timex.h to probe clock_adjtime
Date:   Mon, 18 Jan 2021 14:38:00 +0800
Message-Id: <20210118063808.12471-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is not a part of standard time.h. Glibc put it under
time.h however musl treat it as a sys timex extension.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 155dda124c..1a9e1afa39 100755
--- a/configure
+++ b/configure
@@ -4039,6 +4039,7 @@ fi
 clock_adjtime=no
 cat > $TMPC <<EOF
 #include <time.h>
+#include <sys/timex.h>
 
 int main(void)
 {
-- 
2.30.0

