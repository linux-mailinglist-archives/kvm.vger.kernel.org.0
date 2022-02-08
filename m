Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592AB4ADBFD
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379396AbiBHPHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379148AbiBHPHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B6B0C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 07:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644332835;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=ecaLKA/hOR1xfY7URkvx1/2bPFj3/kDmUiEZPXuEGM941PpdwnU8oedSIlYPYMrbzrb1Cg
        kBgE8JCINq4mMIVHBP2KMr6IO+mLLdXv9Le+9/rTJ28HCK+GFgtqd+5oHMge1dulL0WdoN
        gh5434P9CeGVGuow60z/+Wj5fIycoTA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-LzCGp1s0MZuNswX910eLCw-1; Tue, 08 Feb 2022 10:07:14 -0500
X-MC-Unique: LzCGp1s0MZuNswX910eLCw-1
Received: by mail-wr1-f71.google.com with SMTP id j8-20020adfc688000000b001e3322ced69so1446777wrg.13
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 07:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=V7wLlkrmLXukkM95Tdlipv7UcsMlKr6Y63byLbZWu28tPJSkHtG2BMd3aD473QPNeY
         77QhY/YmOjJWqYo0kIghFf1T7fLVg0AoN8dinV51bD0EPuf7s6a5ScjAFJAlNRRh3LmW
         ZNw6lByn0TLamgEA6BLkBJ5Fer3ug0h4amPqCUb/wUEfRHnPuWXaRJE8cJMsf4AqkSg+
         elNVmIe9oZTdJd77V5n34ekMZJBp0DxqVKwrJtoO+o/Rw65jNlouQo5pR37icsp7/9kP
         uKyzr+NvRY5aPNJJOZAJaZiz0t0x1NgQDR02pg0dYdxDsgMGtLMIA5MJbzsKw7ukuTTP
         9reA==
X-Gm-Message-State: AOAM533px9mZzqVuVM7BqtHwd5+hfnc8osk7jbLlHaoH1FwmUfQSvxcl
        jxj91uIwge3uHClixN+5sekwv3bDmi6kOd1dczr2vSdfeYB5HvcMPRpUlYmwz3+7b0fR8YqMqeV
        CzTyeaAAZ+JcXAPuFK0YYrWaOXXnEWvW8B/tjimQvGFVRecQy3wkQKJ1B5dfKDbD/
X-Received: by 2002:adf:f54d:: with SMTP id j13mr3722698wrp.596.1644332832988;
        Tue, 08 Feb 2022 07:07:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2UiyJSQeSGcLexVZ3CFBHpaxf/eyRS45/KDjXqpi+ZTlnuHgAwYp1zFFxrynMcAjVoTkJGA==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr3722684wrp.596.1644332832762;
        Tue, 08 Feb 2022 07:07:12 -0800 (PST)
Received: from localhost ([94.248.65.38])
        by smtp.gmail.com with ESMTPSA id k28sm1996834wms.23.2022.02.08.07.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 07:07:12 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2022-02-22
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 08 Feb 2022 16:07:11 +0100
Message-ID: <87bkzh75y8.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

