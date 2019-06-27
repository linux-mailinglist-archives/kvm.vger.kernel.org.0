Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0296E57E12
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF0IRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 04:17:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37466 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfF0IRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:17:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so4686093wme.2
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 01:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RmjFFyBvDQn6Xfu0Q/BuVkvS+UCn+TuhSSD5OUjhRJI=;
        b=EO3CbAlQVnGRegZI22j9ujthi9ZBm0hOoVxPWLx9ZIIuaKXftwbtXqvV7YdVHDnTX8
         MCkR1qUF5OAxe2F3y8Rgh+biGldQcRnW9RdPC1ukxWzVSFfzsAqXMxwI57wHy2cqt3dU
         FUKbRyPfYlUstZI8rjRcFFN9zGQG0QKuVVnhmbwlPs97ICa7X5sud6dXkG8/DPrDJIcp
         W5OsDdrLGFVIohlXg3PH79x4jka/GiS8gyVAKIOUDjbNbqtaHaVSVfmusn4PvKcrXpPN
         BUnABZQMrnEhdIfpZp5IrwuXB4+5f533NTP//rFDxjCdfyrpfYMbsur65UYaMu+Kwh+f
         feCw==
X-Gm-Message-State: APjAAAWZwgUWGCF2xggxNGXvtbK6ZO578jcpb2rRW+TlFNYGWIHfMbsF
        zVax1tFeGaNOifsHQREI+MQTSw==
X-Google-Smtp-Source: APXvYqz3R18OS3WEjLZ+sqKqP/ULCckrvtGOJ16Yd4BZO4NaYsCWsUcLjTip7leqUVtkXS2VltM4KA==
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr2010355wmj.87.1561623466915;
        Thu, 27 Jun 2019 01:17:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:41bc:c7e6:75c9:c69f? ([2001:b07:6468:f312:41bc:c7e6:75c9:c69f])
        by smtp.gmail.com with ESMTPSA id i25sm1753308wrc.91.2019.06.27.01.17.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 01:17:46 -0700 (PDT)
Subject: Re: [PATCH 0/2] scsi: add support for request batching
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
 <yq1lfxnk8ar.fsf@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <48c7d581-6ec8-260a-b4ba-217aef516305@redhat.com>
Date:   Thu, 27 Jun 2019 10:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <yq1lfxnk8ar.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 05:37, Martin K. Petersen wrote:
>> Ping?  Are there any more objections?
> It's a core change so we'll need some more reviews. I suggest you
> resubmit.

Resubmit exactly the same patches?

Paolo
