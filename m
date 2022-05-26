Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC2A5352D0
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbiEZRlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348375AbiEZRlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:41:00 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F2994F4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:40:57 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id m6so2506627ljb.2
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k4helLc1TmDSEwXmiCs5QiYPrj5FBkBozIdjKOYuQUE=;
        b=dhgKCdG7roruBbW413X6dxZWnGZQwZz7UNMk6YAlwtLIIGIr3ti5GQYmE1Lky4qvuG
         V0QliZpLJfE5s5t8xN004kkvCpeqnWVV8+N4ggyTPWHH9obELDdHn5BnoRbah5K6Nb8o
         De8q0h4fnYgu1LZEUSgtiAeiyBN8dIi7t544RNZmyZWoii5oxnWN3CzWz/T8tsDIY3qO
         PFLt36nrLmmPuJ75egkhMWyGYHXk8In1yNVvBpS7/HJAfrHagv9Gb07vPcV45wC3WKR+
         W15iAfDepY34Er4jLetOIPAiXYFcTEIyCFUDaci1Kfe1Z36X0vGFo549Uf6+VpUOTidU
         EMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k4helLc1TmDSEwXmiCs5QiYPrj5FBkBozIdjKOYuQUE=;
        b=vSxNDubcCsyzF92g+/KriVxzgXZC5J8xPYfVSkCcxxVoffiHIOrXyUNZc7fMO4O/Ef
         YOzWYvZKA03UBAe08j2nJA4G0VYhjiVi2kq2/t/uUS/eYa8T/Awc0j5E6pJ1dig6zV6/
         IKfzDitWexLP2YMdLzhlD9Q/voS6721HU5e+rOOgsYN2RiAfvVKB5Yr3w45kztog2kJ6
         +j2QmC8pY44FRgA24yukT2nbcY/Q3wHCclDckXCgy/iwIDKp/kBriZ7ZRuXwbfkdxkls
         Pe13hqhq8K3A6ttu3EWogUAUwb9z3xRa8uZ5ov9jTjJlYvxmuzdiK3MNUhugzR54VwZS
         NO8w==
X-Gm-Message-State: AOAM533v0grlEIoK2+aaxgK9V7jDPO37ZRYG5DdR5u1Epxn/y32cS9Jv
        dASto6fjcedduBPGv/7G3fXA89wNxUuIVh9dgWECkQ==
X-Google-Smtp-Source: ABdhPJy+5WqGwtUMve1EHf6VYGaqCLn64dzWOSaoZqiXEvC/YcJ/xaHgHgpPNJjKn9oSp/R7oLYMPBWx4JRGI+7JaF4=
X-Received: by 2002:a2e:bba2:0:b0:253:cccf:a967 with SMTP id
 y34-20020a2ebba2000000b00253cccfa967mr23107791lje.298.1653586855487; Thu, 26
 May 2022 10:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <Yn2ErGvi4XKJuQjI@google.com> <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com>
 <CAA9fzEEjU9y7HdNOkWTjEtxPDNxTh_PDBWoREGKW2Y2aarZXbw@mail.gmail.com>
 <3cbdf951-513a-7527-ece6-6f2593fbc94e@redhat.com> <20220526071156.yemqpnwey42nw7ue@gator>
In-Reply-To: <20220526071156.yemqpnwey42nw7ue@gator>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Thu, 26 May 2022 13:40:44 -0400
Message-ID: <CAA9fzEFOyCoiuY0DZvohCN=BASaMF78oqkCnxyQDso-a24y9oQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
To:     Andrew Jones <drjones@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 3:12 AM Andrew Jones <drjones@redhat.com> wrote:
> On Wed, May 25, 2022 at 09:44:33AM +0200, Thomas Huth wrote:
> > [snip]
> > Fine for me if we remove the check from configure, or turn it into a warning
> > instead ("Enhanced getopt is not available, you won't be able to use the
> > run_tests.sh script" or so).
>
> Ack for simply changing the configure error to a warning for now. Ideally
> we'd limit the dependencies this project has though. So maybe rewriting
> the run_tests.sh command line parser without getopt would be the better
> thing to do.

Sounds good. New patches inbound. Thank you!

        - Dan C.
