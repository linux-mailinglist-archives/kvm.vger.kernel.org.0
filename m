Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E05266347
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgIKQMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:12:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37701 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726242AbgIKPg0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 11:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599838571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1Vgf0GJP4IOhV28Qgm9ynE5YN2wOxiU7sDRaMA2Zgk=;
        b=DO9Oy/2gVolZIYBtH1eOVo2wCOjyAFXdtPa/uid6VhkrlZvPvZSR7FJrKiKoVBDFJOTSto
        I1J38ySGaNlcuunfhcn6A/ajX7QnztIoS/HIPV6hjCgEBalbt7Ch6jLa98xwP4CCpgbhuA
        0/rtU+l00rBSVTUmsjuKx+rX1Htxh14=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Pd3aj4NqO7ioukKWJM6RsA-1; Fri, 11 Sep 2020 11:36:09 -0400
X-MC-Unique: Pd3aj4NqO7ioukKWJM6RsA-1
Received: by mail-wr1-f72.google.com with SMTP id n15so3611563wrv.23
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 08:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l1Vgf0GJP4IOhV28Qgm9ynE5YN2wOxiU7sDRaMA2Zgk=;
        b=AkOMWXZpArTj1eFWBKbf5wZeciJ5TsdXSKK/XK/B17skIahbEBK0fUBUzluVdSNTGM
         e/yt1EYCI2ArhnGz5fm4EgJ9+UDRL7RomideYnA2o4G8ADhf7XSSV3U4JUhA88FBmYPv
         obIForsQGTsJYvhmLioyoPaGI9yQPSsFx3Eq0KuY/aAJuIjZzFu8BsXU9iW4OVgY+2NV
         dkT9Pg4nCzqBedrL7r13onI+4OmgTaTYmgQeeU9WxIM8SP6Qy2rtKiKH4sLWZ296TqFG
         eTgue95Bls3KBMCpYOVaELI1asmB8i4K3/m0gBPMrVWu++ZzW4lleiI27vUERzO31SjT
         dcDg==
X-Gm-Message-State: AOAM530fKpw9zFMLetZ0hujU3nbdFN0iFueu+HukUB/29u11kNHUOzVh
        V0UA4i+Y+NQDUkgjjbnRWyfr6Nk+Pwb5wambCHMPcoracBecOgpWXT//RmWyXMNsz/fuNdyIIG3
        oAkZMxTc/E7IV
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr2909680wmo.183.1599838568015;
        Fri, 11 Sep 2020 08:36:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsM3pCKc39uXnSXlaqfyv6yudTWPnc8/0HUvCM5Tl8PynXwfuI4/1OPMsJZ8j4Hq/6SlWvAw==
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr2909660wmo.183.1599838567828;
        Fri, 11 Sep 2020 08:36:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5568:7f99:4893:a5b6? ([2001:b07:6468:f312:5568:7f99:4893:a5b6])
        by smtp.gmail.com with ESMTPSA id n124sm4982828wmn.29.2020.09.11.08.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:36:07 -0700 (PDT)
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com>
Date:   Fri, 11 Sep 2020 17:36:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/08/20 23:55, Jim Mattson wrote:
> Moreover, older AMD hardware never sets bits 32 or 33 at all.

Interesting, I didn't know this.  Is it documented at all?

Paolo

