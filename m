Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E7D53716B
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 16:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiE2OxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiE2OxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 10:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C864D93476
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 07:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653835992;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=JwGR3d0oiT0dsqnoLfeQLBd0Co4md4pVRicczaDfW7LwZ839nw5GQyu3gor6AtAgBHyurv
        1+Yr1odsN+oxMqjvOd91ojPA7F4qHmWUF4mhmVc9SMTtrpyU4w+wzhJ6WjL/CQt/hHN0kP
        0ubnegxdW1xqA1vSeo0Uau98PAmt7Qw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-wNkBgx4iPemG0quCJ5a3zw-1; Sun, 29 May 2022 10:53:09 -0400
X-MC-Unique: wNkBgx4iPemG0quCJ5a3zw-1
Received: by mail-wm1-f71.google.com with SMTP id o3-20020a05600c4fc300b003946a9764baso8143936wmq.1
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 07:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=l2kNC75wYESKDcCCbgkvMXsPe+2T3VTmEqrNysfQl0Of3RfK4NEqW4JU2cAPB6H8ub
         P5vRtPQzjN6wR+BvkvVBCOEMJgV1rfFg/gTg9miH9q4p+ktYcmyDkYUofDhWMj6gNdLs
         oCWSBdJK6gk/vmul6evsU6XAtY1tzWb0L9kUKICl25np4pkdp7kNnGuzamwTr5S54nBX
         zanuUHsMDvaFCVUU0IpJP28kRZMhXmYvVYz0mE1ylsDm2wRD4vfhekMCu6AhbDLtImDf
         9b/IUHC/AlFA7IPnFaKs3fnRw6QvGa7QzKij9bG7c8b50oy/XU5xtT8zCAYeqPHcc09v
         A4vg==
X-Gm-Message-State: AOAM533rMCuS0531nst/2i7802793jUd01YVLdVw8B2P49LPhxrjpLM2
        UxE95jPPtzLMlghHYEOHsZWfRFK1YXN2xtw2DLKaiy102N9UyfnsgedbtxPE8n73wvDK62jF9Pk
        +QDXsOr4bEMzdciIfKcVH9HQD+3V3ZNBeeN0VC5dEiH1F4Muz/JZT0jnyZPv8PvYo
X-Received: by 2002:a5d:59ae:0:b0:20f:d007:be25 with SMTP id p14-20020a5d59ae000000b0020fd007be25mr30091472wrr.336.1653835988083;
        Sun, 29 May 2022 07:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJHLa5IQXJOpjPT3PaFLOeAKuYrTO/3jsZLnuHRK8spE53SE7hxPZhAcvED7dDPT87NfAYnQ==
X-Received: by 2002:a5d:59ae:0:b0:20f:d007:be25 with SMTP id p14-20020a5d59ae000000b0020fd007be25mr30091451wrr.336.1653835987759;
        Sun, 29 May 2022 07:53:07 -0700 (PDT)
Received: from localhost (static-110-87-86-188.ipcom.comunitel.net. [188.86.87.110])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6d81000000b0020e63ab5d78sm6568872wrs.26.2022.05.29.07.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 07:53:07 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2022-05-31
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Sun, 29 May 2022 16:53:06 +0200
Message-ID: <87v8toxuel.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

