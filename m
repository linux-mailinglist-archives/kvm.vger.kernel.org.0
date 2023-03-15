Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13AE6BBB22
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjCORnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjCORnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C2F60422
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so1579092wmb.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDK+aMGOP0xpM2yh43emDI7/ZdusXKwC3yy2K8RboBM=;
        b=cYPfFClnzeGxmVf2UT21TxMcZfXew1UtQ5Edief9qGCRA9JNtB+9QK2k3Xl5/eBKxI
         ThWW+wzyYQYFhzb1zvoGoW40K7v9Oh9fUFg6eb+ggaj5gnZzAjYq1hxLktXyfkLcRr+1
         Olsp3LHclUSQ5BrukvA2cL/7uahUoLbUD9gNX6+R/JhPbGe7pR6lTVUFHn5jaUrNzm3d
         TvgtySdTuAMzkZOVkng2cducQ/KpL+VbuAkmwLZqRemLeECL22o4jgN9qukPzR771bcJ
         ZLPss0TtYhugedtvJkUiWiVLBJnKcvn+dI1AGtqfaIIphIvbNotOIv+74Dg+vNVUNs5w
         iPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDK+aMGOP0xpM2yh43emDI7/ZdusXKwC3yy2K8RboBM=;
        b=ADW5UFj313iRkA4xmEmKqJ//4c1Zl5my1+nRTOKJvAmmrtwsZMwEHnA+j1R1lfZJk5
         wWTHmc6ltGRQmi2nkvtNelVUDrTNnm4ZaRtIpSP21d2QxNrCDI9xqp+CIC83MMAYCvQf
         kQj4xG7Na7Kbn4yPD7GNSFuQx7OZ+e8gyBSbeTNwsFp9Whlm/4S5iJczQlOX+WoLyPCL
         w7QBaMm56EqEh5G8bebJxU5cAolrZG7Ze0uKq8hTA9gYyNWIdOgnvO09Flrn0icn4eLg
         cZ2EDXhbY1MULzEIOBG44f7OQYp8iqnAjO/TONPLKup8m192/o0lWkP1ChM8KPJTSz2y
         AX4g==
X-Gm-Message-State: AO0yUKX0VWU0bk4UUbxF8gF2pdyNiwdEXcbsqVPKAS3FmP1pucFftvB4
        acigYrcHm7eIjssD5EeDFOPzBw==
X-Google-Smtp-Source: AK7set/xSPkLvfPT1qaYroj+6edT+RCF7odefWN77EjFTzedLk23OYdtT/ghErp0bV07XdjMqbLyXA==
X-Received: by 2002:a05:600c:3595:b0:3ed:2ae9:6c75 with SMTP id p21-20020a05600c359500b003ed2ae96c75mr7167285wmq.37.1678902216454;
        Wed, 15 Mar 2023 10:43:36 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k23-20020a7bc417000000b003dc5b59ed7asm2518931wmi.11.2023.03.15.10.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E55CE1FFBE;
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
Subject: [PATCH v2 06/32] include/qemu: add documentation for memory callbacks
Date:   Wed, 15 Mar 2023 17:43:05 +0000
Message-Id: <20230315174331.2959-7-alex.bennee@linaro.org>
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

Some API documentation was missed, rectify that.

Fixes: https://gitlab.com/qemu-project/qemu/-/issues/1497
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/qemu-plugin.h | 47 ++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
index d0e9d03adf..50a9957279 100644
--- a/include/qemu/qemu-plugin.h
+++ b/include/qemu/qemu-plugin.h
@@ -481,17 +481,56 @@ uint64_t qemu_plugin_hwaddr_phys_addr(const struct qemu_plugin_hwaddr *haddr);
  */
 const char *qemu_plugin_hwaddr_device_name(const struct qemu_plugin_hwaddr *h);
 
-typedef void
-(*qemu_plugin_vcpu_mem_cb_t)(unsigned int vcpu_index,
-                             qemu_plugin_meminfo_t info, uint64_t vaddr,
-                             void *userdata);
+/**
+ * typedef qemu_plugin_vcpu_mem_cb_t - memory callback function type
+ * @vcpu_index: the executing vCPU
+ * @info: an opaque handle for further queries about the memory
+ * @vaddr: the virtual address of the transaction
+ * @userdata: any user data attached to the callback
+ */
+typedef void (*qemu_plugin_vcpu_mem_cb_t) (unsigned int vcpu_index,
+                                           qemu_plugin_meminfo_t info,
+                                           uint64_t vaddr,
+                                           void *userdata);
 
+/**
+ * qemu_plugin_register_vcpu_mem_cb() - register memory access callback
+ * @insn: handle for instruction to instrument
+ * @cb: callback of type qemu_plugin_vcpu_mem_cb_t
+ * @flags: (currently unused) callback flags
+ * @rw: monitor reads, writes or both
+ * @userdata: opaque pointer for userdata
+ *
+ * This registers a full callback for every memory access generated by
+ * an instruction. If the instruction doesn't access memory no
+ * callback will be made.
+ *
+ * The callback reports the vCPU the access took place on, the virtual
+ * address of the access and a handle for further queries. The user
+ * can attach some userdata to the callback for additional purposes.
+ *
+ * Other execution threads will continue to execute during the
+ * callback so the plugin is responsible for ensuring it doesn't get
+ * confused by making appropriate use of locking if required.
+ */
 void qemu_plugin_register_vcpu_mem_cb(struct qemu_plugin_insn *insn,
                                       qemu_plugin_vcpu_mem_cb_t cb,
                                       enum qemu_plugin_cb_flags flags,
                                       enum qemu_plugin_mem_rw rw,
                                       void *userdata);
 
+/**
+ * qemu_plugin_register_vcpu_mem_inline() - register an inline op to any memory access
+ * @insn: handle for instruction to instrument
+ * @rw: apply to reads, writes or both
+ * @op: the op, of type qemu_plugin_op
+ * @ptr: pointer memory for the op
+ * @imm: immediate data for @op
+ *
+ * This registers a inline op every memory access generated by the
+ * instruction. This provides for a lightweight but not thread-safe
+ * way of counting the number of operations done.
+ */
 void qemu_plugin_register_vcpu_mem_inline(struct qemu_plugin_insn *insn,
                                           enum qemu_plugin_mem_rw rw,
                                           enum qemu_plugin_op op, void *ptr,
-- 
2.39.2

