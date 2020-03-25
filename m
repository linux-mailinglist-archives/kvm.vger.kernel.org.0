Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EE8192D38
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCYPrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:47:42 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47048 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727701AbgCYPrl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585151260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nuz/yM/JP2Ju3ycYHc+H+ZDdkaQTUq2UJ1yqZcPleUI=;
        b=YXfSgHcaX2/yTs/cu1LO4bBB/T1rGVIxzLskCq7HSZnkue6IvbQz9Wj3sYEAS2UbTqr5Xk
        27C+rZsERj82+SkGldsXEDDczYj04sXwNSFnxNJ3jXT+Klo9U/nlbv1yxRV/mP6nKG9+P8
        11y7lQmGc/a8iUz7o4nUDXwXwHrb0aU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-s8iRxyyvPjiuPxB52udN_A-1; Wed, 25 Mar 2020 11:47:39 -0400
X-MC-Unique: s8iRxyyvPjiuPxB52udN_A-1
Received: by mail-wr1-f72.google.com with SMTP id o9so1329368wrw.14
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nuz/yM/JP2Ju3ycYHc+H+ZDdkaQTUq2UJ1yqZcPleUI=;
        b=E0gelq0pF/VAP0MY7I6gDC0EblxRCtwMv8DqOi45GXBfpSbv4IO5PbyQirXEUiDQRE
         ppZab1tVdM+L1DGRQmMcyxRiunIdtSwE4rvDukd0GxRKvsRjiwnHQ2ZWI3D0NcQPnOXm
         d8PA49cclbShhVkXv6XgU/4I9HzQyBHZiVQlLfCujVOcCGti6yLbG9tq02sKyZsU1/dW
         S5k1+WR5a4CDvkiLVct8HquV/+9qHqsspqi665AYa3CKqwneTdO/oX7eHY5YkbJMiJ0P
         lGkG9iOKU14MoUcbqv/JB1DAMcV7tPgngOIRFoYu/N/niw35OBMl0Nu2g459zaYlSh5I
         ygYA==
X-Gm-Message-State: ANhLgQ3TAbY33+BYTUnJNM5t6XrqnRCDlNgX8OXiLEh6Xto8ujhbTRSG
        udI9cASf3Cs3G6kSrWjHpOgctfMjkN3vdzCPEGDxWpyrwg6lmqJhho1Q8VpRrtevssedpL3S6Ur
        3O2H0IyNaXNAu
X-Received: by 2002:a5d:640a:: with SMTP id z10mr4341698wru.301.1585151257947;
        Wed, 25 Mar 2020 08:47:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsFhVIS29FrVxXhhrqH8g2i3wfUlgTpFMueIaZX62zRUFATQRyOlM6tQ3FsFA6xvFPV4G4w6w==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr4341677wru.301.1585151257712;
        Wed, 25 Mar 2020 08:47:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id a1sm34722213wro.72.2020.03.25.08.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:47:37 -0700 (PDT)
Subject: Re: status of kvm.git
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     KVM list <kvm@vger.kernel.org>
References: <ba6573bd-274e-3629-92f0-77eb5b82ac40@redhat.com>
 <20200325153557.GD14294@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cd788f0-a7cf-3dc6-42b0-0e7a2e9d7f27@redhat.com>
Date:   Wed, 25 Mar 2020 16:47:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325153557.GD14294@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/20 16:35, Sean Christopherson wrote:
> On Tue, Mar 24, 2020 at 12:53:11PM +0100, Paolo Bonzini wrote:
>> For 5.8 I'd rather tone down the cleanups and focus on the new processor
>> features (especially CET and SPP) and on nested AMD unit tests and bugfixes.
> 
> Roger that.  Reviewing the latest CET series is on my todo list.
> 
> Regarding SPP, I thought the plan was to wait until VMI landed before
> taking SPP support?  Has that changed?

No, the latest VMI series included SPP but the code can go in separately
since it has its own selftest.

Paolo

