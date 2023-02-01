Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816C4686AEA
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 16:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjBAP4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 10:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbjBAPzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 10:55:45 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B2B7578F
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 07:55:30 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m11so17744062pji.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 07:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UKN0hCxvbVEoS1CGwDslwENkRBIYFzof8kgYWh+ErNQ=;
        b=PTfauKBugbwxPF1ppL2NcF8OCLSPY7KPya1L/9+KIZUGVsAKGgxYna+k6lBTmoNqg2
         o8XhJKvK1cpgezAocJxaxfBgAogqMMd92JjL55YSRdXcWKqKHGWmSFx89FTP5C1gbYLi
         LHPzY6bJ+6yGCzB98ff1b9Oxps1+0KZMVY5FIe5st9BElvXOVjOT4SPAc5Ba+JSI09TY
         A9PTuNFsl7SyX6FF6h+7gcQ2S5CxLovm3IbIDxtJajcW7TAaafz1t7ZFkXidgoJl0r8T
         NnWlDZ36SiGUInMtlK4C7+qKBdkb0pOzytHaiNxyEDzAkpkk0NMwYd99HrIZTrIlPEI4
         d2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UKN0hCxvbVEoS1CGwDslwENkRBIYFzof8kgYWh+ErNQ=;
        b=iLzZTEbV4iYXVLEJm+3v5L9B/M6lv+Sm2AsVb9h0lSOTRfLHCTbKWRMiEvtsm3QJON
         onLjZ4OtkbeeIxdqb4kXdtswraCmZRfLOgoF1HjW8P/30BtGRHPOw2tHFN23SwDFaiGO
         z2z9p3tdQjgHio3aAerIgMSm+PQ16vOtKsTeGxnVDPE96Wq/qJ1W7ut7FOtzQl2alywD
         TOSrSijZmeJ3hcntnZ4hK66wfj3yR7cwAm2+BEjWQhi6Y5Hx4uvt88TqoFiHXdFx4ASf
         EdC9Q+ifvwEKpXf9ODDyM1C30UzFegOBL/AT7wfRkpnqEB9YjpDv6JMLXjSpuhxTuuEy
         0r8A==
X-Gm-Message-State: AO0yUKXs8b94IGWOxHg0oLyO5FkuisPC2zHeICfSrl67tG2NL6D+GYxU
        QZ8kb1uvmYF0sKGnChpycH3p7zKgjjJ8FH30YC6SEQ==
X-Google-Smtp-Source: AK7set+5sivLmBoHQHDMXaqW2OIVufOpfEJc2w0WYvzyCi4CALl0D3F2RP4pgqgdx4UdJEB5LutPDmJ0CbjzNLUdkSQ=
X-Received: by 2002:a17:90a:670c:b0:22c:46e:6510 with SMTP id
 n12-20020a17090a670c00b0022c046e6510mr509931pjj.9.1675266930255; Wed, 01 Feb
 2023 07:55:30 -0800 (PST)
MIME-Version: 1.0
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com> <20230201105200-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230201105200-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Wed, 1 Feb 2023 17:54:53 +0200
Message-ID: <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain fails
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I'm not sure this is a good idea. Userspace is not supposed to be
> able to trigger dev_err.

dev_warn then?
