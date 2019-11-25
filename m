Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B9108BA8
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfKYK3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:29:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725828AbfKYK3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:29:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574677779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DMX+4DjoA/HeaRN7qAer+GRB8f0jc/420ZRTLAZw6fQ=;
        b=fPeZhmwHnVGd3x0ZrMzkSiyEqwxOX7jMkI7tdmUwjae48ABM1VOVcEOk2lf7e+M4+2qsrK
        Acf3hWj3qGKvs/o6/VqkvXrzmXCi1wJ2ZcDF1AJMK+R28unWF9SgjFOm4wKFfC8Aw2W6YY
        cII2Q63Vl7dYdI1TZn9ley8uu8XAwA8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-R_0e3jXwMS6O1MvkQSelFw-1; Mon, 25 Nov 2019 05:29:38 -0500
Received: by mail-wm1-f72.google.com with SMTP id q186so4412111wma.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 02:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzKy0BDo0TyBU4g7o2ffXKqI/Ei69F9XOzZU0Y5BBLQ=;
        b=YfWip1KMhF74wcvH9gkrANjSdpZ6g3MdwAZzyD3ixMpO5Okyan/Kh0q8OzZFG3DsVU
         hLEVuCG1olClh3Ydl7s8fPPkSwXggkPjMvJDwGoWZ1CZDFeIUe559pgtEieFyW+3bsuo
         QitMK6qO2Yn/rrfVAuaDUHSjqLVnSszoSr97KHhm7LcV2xRP5iow7r0DT5FI92i2mIZ2
         89pVHpZuowr05DbPvUD4/sB18eLoBeX62HeYsC67BV/uFLn65VFJbHy2piCuCbSM6an6
         ctJut8xzjANalMy8tLQnl5L+8gJRmNWR904Py8hEITA1QCddOQp1QvacMdC6zffuUN2E
         qRUg==
X-Gm-Message-State: APjAAAUCFwIqaVWpQvx9lO8jORLiJh0A1ahnPQsS1+EIWYg+f3nolf1i
        DKOO8YfBr7SaNbpy/qVqgpIp8QNrXg6hhSiEQmlAp9QwKhPMxE4HqYWHQRqXZOnQJlErbF8qF9u
        T8vJh65wZNKqp
X-Received: by 2002:a1c:20c6:: with SMTP id g189mr14762782wmg.6.1574677777307;
        Mon, 25 Nov 2019 02:29:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwwhMeeOtg8TNe50FFjcVTwaf4a/llhmoMUoDQqAulZUKJiWuX5XpjgyQySM3zdZ1flOnc+IQ==
X-Received: by 2002:a1c:20c6:: with SMTP id g189mr14762758wmg.6.1574677777016;
        Mon, 25 Nov 2019 02:29:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id b15sm9691730wrx.77.2019.11.25.02.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 02:29:36 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.5-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Greg Kurz <groug@kaod.org>
References: <20191125005826.GA25463@oak.ozlabs.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <eff48bca-3ef0-8ae4-79d4-5e8087bded1a@redhat.com>
Date:   Mon, 25 Nov 2019 11:29:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125005826.GA25463@oak.ozlabs.ibm.com>
Content-Language: en-US
X-MC-Unique: R_0e3jXwMS6O1MvkQSelFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/19 01:58, Paul Mackerras wrote:
> Paolo,
>=20
> Please do a pull from my kvm-ppc-next-5.5-2 tag to get two more
> commits which should go upstream for 5.5.  Although they are in my
> kvm-ppc-next branch, they are actually bug fixes, fixing host memory
> leaks in the XIVE interrupt controller code, so they should be fine to
> go into v5.5 even though the merge window is now open.
>=20
> Thanks,
> Paul.

Yes, of course (I have even accepted submaintainer pull request for new
features during the first week of the merge window, so not a problem at
all).

I'll send my pull request to Linus shortly.

Paolo

