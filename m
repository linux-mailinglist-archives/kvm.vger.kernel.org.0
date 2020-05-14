Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483FC1D2FC7
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgENMbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:31:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24856 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726124AbgENMbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589459464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=frywLqfG1R91mbCHc3ZBnIeAU75GXxgompTLDZ2QRE4=;
        b=ftpo7zlXbvPQ8n8jhOey4bjiR/WPtawrDrZ7eqa5WHnnsqODSea3fAuObJ4lIMkE74eqRX
        j6MK4LG87374cdSNZVrJQQPSGMK4pySu/KyhP2rAPkzcY2y0+BsyHFeOrlEh7qBTIooK7t
        vEFwCWfLb+IyF1WpFFlnUdTkBqVHZKs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-VSRM2a64Mf-cbvWMhkQX5Q-1; Thu, 14 May 2020 08:31:02 -0400
X-MC-Unique: VSRM2a64Mf-cbvWMhkQX5Q-1
Received: by mail-wr1-f72.google.com with SMTP id p13so1527563wrw.1
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 05:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=frywLqfG1R91mbCHc3ZBnIeAU75GXxgompTLDZ2QRE4=;
        b=qn1HPhdObnhiHY/gr/T8ckXMYLaaRr/7RpOwglziNLXnYif3qsdnOpAPAuDx/cWQ2Z
         sjA0JoFe0Sy38gSTB189pHxu6Qzain0TgL4lEqe2Tbwo/Q2LM786rNyODmkD+iqdnrQ3
         YqWlI9lF2tkvzRkLr5uvlDVzf2PyTYCzeAp2Y12Vwx+fX1OpFwnmpuq3/HTI6w+B9rbw
         QjOTOJmRkiN15lXg6RelBngxCcCDDniAgE9K2BeQS2v6zalqfgv+cON+aExuCf4A8Ud5
         hLCj/Z9IAn7lQ/+uvdmYCDRbYJmVRijET6VrLEVY74N/jknrQcxziZA/5yg1eK/TFfix
         0v9Q==
X-Gm-Message-State: AGi0PuZKQadSnY/yjqz23pxAsC2RYDg9bri10E3J5K/xLpliGqJWMCzM
        boDmHCVG1ismNPBO/jMHNEnNiZ0QyJPaXHr8arF4P3VerqTu1L+ruyscauxoZDmaQpiFEc891rq
        SB8uT+sOPl2VE
X-Received: by 2002:a1c:7513:: with SMTP id o19mr36389117wmc.104.1589459461467;
        Thu, 14 May 2020 05:31:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypIUPPSBfapZ60zVonnmdDLWxdm3soiG5GMfFOGJoimgraokix6hqGPwNPdN/FmmEcJXik70Bw==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr36389097wmc.104.1589459461222;
        Thu, 14 May 2020 05:31:01 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.85.171])
        by smtp.gmail.com with ESMTPSA id n9sm18058896wmj.5.2020.05.14.05.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 05:31:00 -0700 (PDT)
Subject: Re: [PATCH v3] docs/virt/kvm: Document configuring and running nested
 guests
To:     Kashyap Chamarthy <kchamart@redhat.com>
Cc:     kvm@vger.kernel.org, dgilbert@redhat.com, cohuck@redhat.com,
        vkuznets@redhat.com
References: <20200505112839.30534-1-kchamart@redhat.com>
 <c8bb56a1-8556-a9ff-7b69-caf116729a23@redhat.com>
 <20200514111300.GG17233@paraplu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bf43cea-3df1-6471-b08f-ecf0b76e5c60@redhat.com>
Date:   Thu, 14 May 2020 14:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514111300.GG17233@paraplu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/20 13:13, Kashyap Chamarthy wrote:
>> This is a bit optimistic, as AMD is not supported yet.  Please review
>> the following incremental patch:
> Hi, Paolo; it wasn't entirely clear what you meant by "incremental
> patch":
> 
>   (a) You're going to squash it in the current commit, or 
>   (b) You're going to add it as a patch on top, or 
>   (c) I should send a v4 with your correction below 

I'm going to squash it.

Paolo

