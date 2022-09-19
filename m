Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A175BD81E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiISXTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiISXSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:18:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7324F6BF
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:18:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a41so1393097edf.4
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YuQwXC400wn1XG3lPzRkN46CWgPRCmkTZD5KrMqPnvc=;
        b=OfOTlhHIdUYcoHKPguW/SrroW/2HH31KpnqDNx1VDOdScP9GFw+hcz6wLKt9qwYKmr
         tUiVUE0COMOBBIwnlZk33ru5T+PAhA69FfCE40NYduQ5A2+ZLn3WJwfMhsySvcTEX8NG
         kUvI2CGts6p4THnGkq0xeeKDTU5xPudeCwmi2+6sBCLSQZmuxjpnNtMXwBahzmJp9kZR
         Ylpol3lEYtvuiLAmcekgtLJXtFpD/8AjmspSTSwXdjX14Lafob9CFzE0RecWT58O2Hq9
         Vl+Tlro5icVzofsz7kyjKQ+0/Ll3mwbPbZepIT1+f4hmtu3MFNqsfZTqVJBagsK7iMxp
         9/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YuQwXC400wn1XG3lPzRkN46CWgPRCmkTZD5KrMqPnvc=;
        b=hx8TOYpX0z9pmsnGnT9w8wkLTgwZXe1xnE9LEiyagX8o+OMPujpMG3AmLipt5pFjqD
         i5COkXrwKjiBiK5xJ/q7F4QTSEe6DE8s3/0iG/cVV1392mzRaBGXacZCOMSdOa4KRDH4
         TRDa24OKY9mS7y7DEJ+VysEZ4vfSJ5wIUT02SZvv7q9qr+fUMBRcVP2xF+kG8g6Tza2x
         tUlj1kM4mBXAuRxckNeB0SBJNfnkQujpB2SytLASVyv+zku+BroxU+F3nCiXN1+MAfKS
         8A4pN6iiQAdpP8eFctRcHyeTZ5Mr/BV86vRXH4P7/xAmstPULoZVd3DRNBsYlhFt/NiI
         3/TA==
X-Gm-Message-State: ACrzQf1wYDdP9DZ02nPVPOinV3PgQB9cD2epCijV1VlfF/x93lS08J6U
        +5atPjDmVzT1nPOAxWRxr8Y=
X-Google-Smtp-Source: AMsMyM4dA5dnazvKBz2RVfKC8EJQkafmLFlSOVYf1X2uY4aMLi4DKxlHP7A25Z9KlTvDpLqBqvU2+Q==
X-Received: by 2002:a05:6402:1b06:b0:44e:a073:1dd8 with SMTP id by6-20020a0564021b0600b0044ea0731dd8mr16910792edb.391.1663629508436;
        Mon, 19 Sep 2022 16:18:28 -0700 (PDT)
Received: from localhost.localdomain (dynamic-078-054-077-055.78.54.pool.telefonica.de. [78.54.77.55])
        by smtp.gmail.com with ESMTPSA id rn24-20020a170906d93800b00780f6071b5dsm4800926ejb.188.2022.09.19.16.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 16:18:28 -0700 (PDT)
From:   Bernhard Beschow <shentey@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>,
        Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 2/9] exec/hwaddr.h: Add missing include
Date:   Tue, 20 Sep 2022 01:17:13 +0200
Message-Id: <20220919231720.163121-3-shentey@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919231720.163121-1-shentey@gmail.com>
References: <20220919231720.163121-1-shentey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next commit would not compile w/o the include directive.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/exec/hwaddr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/exec/hwaddr.h b/include/exec/hwaddr.h
index 8f16d179a8..616255317c 100644
--- a/include/exec/hwaddr.h
+++ b/include/exec/hwaddr.h
@@ -3,6 +3,7 @@
 #ifndef HWADDR_H
 #define HWADDR_H
 
+#include "qemu/osdep.h"
 
 #define HWADDR_BITS 64
 /* hwaddr is the type of a physical address (its size can
-- 
2.37.3

