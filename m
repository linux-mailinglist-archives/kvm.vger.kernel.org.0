Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958493754E8
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhEFNjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbhEFNjf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4PLS6ZKiwbiAj4ntOkzSZGX4ZG/Ux0v+1o1vvVJrYM=;
        b=fXK2Y/P9RYah5H5Usg5XD7ROW3+c224PC1hsDZg5WY20szqAyp53YtvBheJC5PVPF5TsU5
        hgY7bylhkWSMTg6H6RbwlkuzzflSaZqnLEuT/RatR7SE3Y5lPRN6LqyoXJp5TfYW/qwlwA
        gisZvPU/Vsr4RHGxWQ6Gvt0jGKpBSns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-0mxKsjtMPtWmK7kH_7XrTA-1; Thu, 06 May 2021 09:38:35 -0400
X-MC-Unique: 0mxKsjtMPtWmK7kH_7XrTA-1
Received: by mail-wm1-f72.google.com with SMTP id g17-20020a05600c0011b029014399f816a3so1337366wmc.7
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k4PLS6ZKiwbiAj4ntOkzSZGX4ZG/Ux0v+1o1vvVJrYM=;
        b=i7fXXwD2HxZm4uG1vmc0UX61/1uOUR4nQiqi4Pu/vtNNJwAWlnL2f9ml7kqTFXdIMB
         juDax4y5Dusd4CRNvwR2zQmORUuFCUz13gtBgvDdEPHhEPtxLTTed1lzVG48aSAHbFdj
         5O0OzwPliiTiNjZDBc9rZfGvPnfeBuc8n4NTaOdvOl9/Kq8OTMt56oaPJFiVN9aL2QTi
         VeIf5DpQg2dKlacopho1c10h6dIMSEj31BZ54n4nD1SWl2GZ4qhXDTgHQ88ZakST15ZI
         9AmOKtoiBqPkz8miMS/3QhnNPdHdxz5Yv3cQnkPGbfcUNic0+igid2iBfXgvdcbBexPL
         Dp3Q==
X-Gm-Message-State: AOAM532+K/EyMFIWkllDv9693Yksfg9zseFK7kL52q8pRFBo77I46qhJ
        lQ5MX9fZ40szz/IXtxAi8rjNhMuTYBPr5d66TMjhxMU4XavXUD06MdlRVrLoMn8pTdskf1YrSm4
        lLiDIQ1grskpL
X-Received: by 2002:a5d:4707:: with SMTP id y7mr5273917wrq.137.1620308314031;
        Thu, 06 May 2021 06:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9OkIRdMCjajJ35Xqm95nwOIWcYI/GC6OCGDnowdoEynI2VdSlNOXJBaO3mbso8BQyxIbuGA==
X-Received: by 2002:a5d:4707:: with SMTP id y7mr5273889wrq.137.1620308313868;
        Thu, 06 May 2021 06:38:33 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id j13sm4830339wrd.81.2021.05.06.06.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:33 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 7/9] gdbstub: Replace alloca() + memset(0) by g_new0()
Date:   Thu,  6 May 2021 15:37:56 +0200
Message-Id: <20210506133758.1749233-8-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Replace the alloca() and memset(0) calls by g_new0().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 gdbstub.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/gdbstub.c b/gdbstub.c
index 7cee2fb0f1f..666053bf590 100644
--- a/gdbstub.c
+++ b/gdbstub.c
@@ -1487,14 +1487,13 @@ static int process_string_cmd(void *user_ctx, const char *data,
         if (cmd->schema) {
             int schema_len = strlen(cmd->schema);
             int max_num_params = schema_len / 2;
+            g_autofree GdbCmdVariant *params = NULL;
 
             if (schema_len % 2) {
                 return -2;
             }
 
-            gdb_ctx.params = (GdbCmdVariant *)alloca(sizeof(*gdb_ctx.params)
-                                                     * max_num_params);
-            memset(gdb_ctx.params, 0, sizeof(*gdb_ctx.params) * max_num_params);
+            gdb_ctx.params = params = g_new0(GdbCmdVariant, max_num_params);
 
             if (cmd_parse_params(&data[strlen(cmd->cmd)], cmd->schema,
                                  gdb_ctx.params, &gdb_ctx.num_params)) {
-- 
2.26.3

