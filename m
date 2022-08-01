Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49F4586703
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiHAJoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 05:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiHAJoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 05:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD1EA37190
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 02:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659347046;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=WNY064kZSpLgzMBnauLkGkHn27j/cODZCJZNcuIvI2YlaxZ/yszi28o+q0MjpoCBHo25Ji
        n9ZqXe0qrVIRe1L4Y1aBqZDL02okkujh2mltnm2wN1V+dIVZ+WrOo6XnYYZ3EA/O5NLtlC
        LJLhZzpHWMIOp5wAA7h1PyE8WVUyvgY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-6tZisGpcNmmiXU9kCzNDHw-1; Mon, 01 Aug 2022 05:44:06 -0400
X-MC-Unique: 6tZisGpcNmmiXU9kCzNDHw-1
Received: by mail-wr1-f70.google.com with SMTP id h18-20020adfaa92000000b0021ec200d50fso2430468wrc.14
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 02:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=uEZ/JlDzYr7gxSKB2hZ34rWljPGmCazUbHu1Nqaq2XpxjBPFkahEaqB8Kb/veH4yKU
         PX6G8EbipV2VquQcnspdMpGxjdgWaHOmR4q0J6PwtgxBSS1lEjKDY8t4b7pTPPF2sOY5
         YgD+D0ucxqbj0z7LG8Ren5ZBVm2JL+pKuLn47gZqYQJO4FahHOAZgiFzUJi34MQYjkQ9
         JdnDeAKh8OSYndpGiN3Z1gNBM48hq3A2AkbW8aC02ppj1CTb+8rl3AOgY963rI3X2o5Q
         /QW0jERQwImkzhKG+q7vj6iCOQRGk83u/6diC5G1zu4zGNSUW/KKInhkLrMcL2Ny4kqL
         jRhA==
X-Gm-Message-State: AJIora857O4yF53CI1x5OeEBxvRpkVYxIPc5AvyN/4pk3o9KKOs3l0+H
        4DqF/TCGQXhdojACY61l5oVd+9O81hkoKIMBjOScKMmbcLHiruhD6odeTz4I4m8EuVnuzhSorwq
        1d2xFpLlcwYudOwC1ZMN1X9ozCYXodzGAOc4QD00B+vPsP0iuULagBTBVC7rMvRwz
X-Received: by 2002:a1c:4b09:0:b0:3a2:ff2a:e543 with SMTP id y9-20020a1c4b09000000b003a2ff2ae543mr10500442wma.93.1659347044621;
        Mon, 01 Aug 2022 02:44:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tOagncrujq+bK70qRqYBSutzT/8BRPd7fNGfTgM7wU8qBQC97KTZWJIzcYDVMxIiQ91cEvow==
X-Received: by 2002:a1c:4b09:0:b0:3a2:ff2a:e543 with SMTP id y9-20020a1c4b09000000b003a2ff2ae543mr10500418wma.93.1659347044366;
        Mon, 01 Aug 2022 02:44:04 -0700 (PDT)
Received: from localhost (84.125.93.75.dyn.user.ono.com. [84.125.93.75])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b003a3278d5cafsm20307562wmq.28.2022.08.01.02.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:44:03 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2022-08-09
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 01 Aug 2022 11:44:02 +0200
Message-ID: <87k07scn8d.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

