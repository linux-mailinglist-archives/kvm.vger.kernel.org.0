Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D031B36F8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 07:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgDVFvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 01:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgDVFvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 01:51:21 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C98AC03C1A6
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 22:51:21 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t199so908621oif.7
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 22:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=evSSN9h22SZxdtBUrRFRaCNtkgNZePgvqWQvMgguurE=;
        b=TRgxXuWWPxVcpbAaq4DXOirYEYxTXypk4VLkNm5imHwNVdEWGSri9/gP7xHOr/37te
         JK0892lQ32LgKjajbK+K4gvxfJKeXa45Pe2aXW3ZYQfsX+Ij6j4AQZNIlnQiwEYqkt39
         a2KoIWolcByn+1OdiEHdVYoSHLZAcyeZ9qjMkjdSdJCtuPhH+0bU8bGj8PI96R83t/xx
         cItyPBLNeUCd4CuzDclK6Oq0OFxy7A8LYIBr8HtpG6gUapAnwRs7hune/cTDgbQ+vvFm
         ScOZScpPs9w1cRlgkllFZNE1hzsrGYe2ApVL49Kmceze6wO4kH46u0HvymXIxaapxYij
         nctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=evSSN9h22SZxdtBUrRFRaCNtkgNZePgvqWQvMgguurE=;
        b=dU8OqbM2zz3vUwLdc8EHDBjAHwvhdA30W9i+ZRRawQd3ozsLLs7yASc9uMIapGeDPS
         HDygqoWCrIqWFOcVLKivPd9WkLM1XKH1QbrIxhl4rrgn5OSj+9fsAdOyJvStn8Upl93t
         px+KPaD4DJjV6AEEU9u465USVgOunHUTk6blw6oP7meRm9L1A3sPUqpRAjmbBXS89Q1y
         +rPiieIcb3aSTD0i7Ie6JxgNnw6kTJYyuX3I9gQ6FDgkUmJk5NpWEHAuWwo2wMW/C5Yz
         EkUOrjkG5c82I/QDFJ/FudQ4Z52/UBdpoCqOTatgp7Hz5xYaImqEEavNwwCSC37XZWgc
         ZQoA==
X-Gm-Message-State: AGi0PuZdapZ1rzfaUkZ95IXZXBAasfGRb5UtaBRfJ1aUwVSDYZQRB08g
        6+1rMA0mhDp2+1b0gC3TcxEcWZfHaVZlewHCt7Ytb1GF
X-Google-Smtp-Source: APiQypKGNXuiCsV1r3uXwojWaTAq7Dhfyldlhg+7WFyoO0gFM0qwO0WTXtEA8VewfO8DEEWY+lBsE8QxJ8RtBlrtElU=
X-Received: by 2002:aca:1709:: with SMTP id j9mr5711063oii.59.1587534680173;
 Tue, 21 Apr 2020 22:51:20 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Anders_=C3=96stling?= <anders.ostling@gmail.com>
Date:   Wed, 22 Apr 2020 07:51:09 +0200
Message-ID: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
Subject: Backup of vm disk images
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am fighting to understand the difference between backing up a VM by
using a regular copy vs using the virsh blockcopy command.
What I want to do is to suspend the vm, copy the XML and .QCOW2 files
and then resume the vm again. What are your thoughts? What are the
drawbacks compared to other methods?
Thanks

--=20
---------------------------------------------------------------------------=
--------------------------------------------
This signature contains 100% recyclable electrons as prescribed by Mother N=
ature

Anders =C3=96stling
+46 768 716 165 (Mobil)
+46 431 45 56 01  (Hem)
