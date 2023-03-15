Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D46BBB1F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjCORns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjCORno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3880E8C58B
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m35so3571066wms.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4cpR7vA6XSXxWS6bHag8gq4h8YFalbW/SrKcN6qWB8=;
        b=gb53RexSl8PB4IaOOG9vTrd+3BcQN0+X2Am1jwD+RpD/rPEOKxUfXSzSe4DYauDoAq
         BwfNcPM8KY6JvnQDUHY8DT1a2Pfcdi8XOIC09K8wbEN8O4vtpMXc84nHnMoAxKVz5XyI
         tl6psBNX6/vGm1pZbEPVmGtME5UQZqlkf8f1ggfc+Ip9lbnFapBhBBEnfMxOf+VWfAyO
         Hp+Uz+k0VMlEgUUmnuUzVttOxbO7IHeQPF2i64pBiNfzLgXIrWnqXT5997lsKogM5Hx2
         KUEHwjinTWn6LdBjwPAtR0KxKxLSMSJ34L3EhUBA72mCVUM64sj3Fej/wxBuwYHz0Ph4
         DiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4cpR7vA6XSXxWS6bHag8gq4h8YFalbW/SrKcN6qWB8=;
        b=Z6lWmbnPZ0iNNm8kARymaxipEPFTEBDReZnBiDnAG5SoKqKVrLNFxFxXDgkUSIlo6F
         pOiClooCh6AAOJKms5eUP9ncG3GpkWOBeqBUtaMHJTIbBAsmK4LJgm/bZEx0b8RjT19D
         KOnFTPCWGtdnlMO5QW4RvVRYKLSei2xdLN96dK1t28OZvkvVZ8X2hhZS4u0k0k52uspO
         TuHGP3sVF2u4zHSLtZ5rui0TvmSDoa6bRwE8Su9iwbatoJ6c7tphoGFiV8/Kvj2o0jsx
         gyO61iPz00V/BsJFd1uBguWhxml/94MqlSZ3In6cqcOa+mgoKGZwhvjBE8rPcI55Tpt8
         Q42Q==
X-Gm-Message-State: AO0yUKUUwtFWx+HpnMNBe9Y8pVgKmXwFK0AoDdoqrE1BLc8qFpNTTdGl
        FATX+hfK9p1UlHebBgRu2jSDow==
X-Google-Smtp-Source: AK7set8ccpwWoZDmzOTQiijck9j+XSpd4UjL6fUJJSfGqnX+7bNlXnVGnlIX0KwhJaRi55ggGz3pxA==
X-Received: by 2002:a05:600c:3d8a:b0:3eb:3c76:c241 with SMTP id bi10-20020a05600c3d8a00b003eb3c76c241mr18093033wmb.13.1678902214366;
        Wed, 15 Mar 2023 10:43:34 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id hn37-20020a05600ca3a500b003ed2002fa6dsm2483791wmb.17.2023.03.15.10.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:33 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8D4A31FFBB;
        Wed, 15 Mar 2023 17:43:31 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 03/32] scripts/ci: add libslirp-devel to build-environment
Date:   Wed, 15 Mar 2023 17:43:02 +0000
Message-Id: <20230315174331.2959-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without libslip enabled we won't have user networking which means the
KVM tests won't run.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/ci/org.centos/stream/8/build-environment.yml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/ci/org.centos/stream/8/build-environment.yml b/scripts/ci/org.centos/stream/8/build-environment.yml
index 0d094d70c3..1ead77e2cb 100644
--- a/scripts/ci/org.centos/stream/8/build-environment.yml
+++ b/scripts/ci/org.centos/stream/8/build-environment.yml
@@ -55,6 +55,7 @@
           - librados-devel
           - librbd-devel
           - libseccomp-devel
+          - libslirp-devel
           - libssh-devel
           - libxkbcommon-devel
           - lzo-devel
-- 
2.39.2

