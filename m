Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FA4528101
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiEPJs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiEPJsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6D3036305
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652694502;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=9yyK63bE8UUfmi0idqaI1cyB5A5o2KAaM3zb1+pGdNI=;
        b=DCsJbcKsSK60FRcNxPPDpQBrDR8qnUGhuJ4IWO59uRM2giDJ5mOsAxtm987DjFWXDStvPD
        rlLoI0/jIt09G3XP0LyZCNFgE7f0JxXtSsj8zwGMYpPIwJ+xZ6/36EDO86riyAp75Bkf7p
        y7wBHO3i0GH4IVIKIU2yhLRw2FSzk+s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-F5UTgR6ENd6rQOlsKwp8_w-1; Mon, 16 May 2022 05:48:20 -0400
X-MC-Unique: F5UTgR6ENd6rQOlsKwp8_w-1
Received: by mail-wr1-f70.google.com with SMTP id l14-20020a05600012ce00b0020d06e7152cso368475wrx.11
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 02:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=9yyK63bE8UUfmi0idqaI1cyB5A5o2KAaM3zb1+pGdNI=;
        b=5DbeBJTXkBRywiuo395nA/4ne5GnAaMJeVldIr5nhRFv5j+Fs0rfsoBK0c7cFTcgBG
         vtDfLYdd0tQavx3h1V46q2tJV4zo9BCIcSyqdg8PFdIjDMhij0uMmuOWi+rCjW5sB6vl
         rsmXMM6btQq4oPaNJveGDcrFusoqari6+zNaznY/0dXm5pi+tozzw4vpNfdbdCw+vFLC
         71mIhYFwcyKLtOTTmWj10r+1wCjeJuz/82q+b0pIPOQFIZkqTNAGFfhe9C4cq5IynrnU
         Ym7xOVmKQuSVAqfw2wR69q/iWMtP3AhRkq8cnoYz0gztBw8u8RiSQ8XO3ZVeX88qOzVv
         XznA==
X-Gm-Message-State: AOAM531gEFgVF/PORrCsN3ywiuz9xcgevtH81N83Kz576aw5eSWlKDg1
        S1TbI6uMxOeQWK4ANyXWfQbpziNBRz/F3mZLgAVbTDX+N0fdH15fQ/Ri1AXiYtHh3D6Y/12F1be
        rP+7GWFTnNOCI
X-Received: by 2002:adf:ed4e:0:b0:20a:c805:1d62 with SMTP id u14-20020adfed4e000000b0020ac8051d62mr13569405wro.134.1652694499767;
        Mon, 16 May 2022 02:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymaqWr/G7KrL4LFQxY9QTJQsqvU8CCyfA43+hENKCPT1TaV8DUnCZZX7Bg1PQHr4cTbZf81w==
X-Received: by 2002:adf:ed4e:0:b0:20a:c805:1d62 with SMTP id u14-20020adfed4e000000b0020ac8051d62mr13569388wro.134.1652694499557;
        Mon, 16 May 2022 02:48:19 -0700 (PDT)
Received: from localhost (static-211-115-85-188.ipcom.comunitel.net. [188.85.115.211])
        by smtp.gmail.com with ESMTPSA id n6-20020a1c2706000000b003942a244ec0sm11677612wmn.5.2022.05.16.02.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 02:48:19 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
Subject: KVM call for 2022-05-17th
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 16 May 2022 11:48:18 +0200
Message-ID: <878rr1u7tp.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

I know it is a bit late for the call for topics, but it appears that
there are people who wants to discuss live migration improvements.  If
we got an agenda, can we have a call tomorrow?

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

