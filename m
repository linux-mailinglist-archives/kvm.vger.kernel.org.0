Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F5C1361EA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 21:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgAIUmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 15:42:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51373 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731319AbgAIUmr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 15:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578602566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdAv7lKgnlnMnq5dqOLheLY3zrBzh9h1Kyp8yaJhNcU=;
        b=BYz/wu9Vp8W7mt5CVgyMn0jYiC7Hg1iSI+Id2Pv06K2t1OyqKUxWB05X0JaplQDaVqoynJ
        O37VT8RSfvFPmLCk/9cynjaPlIgAZI++0QErnnfeODJDXEQe86CiRfCNRZP3OHwCB91jl9
        o7DXRO1gACYHt5LaV0g7F/RP+Yt6VAk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-8-H_Ly4ROBaQCV38V2DubA-1; Thu, 09 Jan 2020 15:42:45 -0500
X-MC-Unique: 8-H_Ly4ROBaQCV38V2DubA-1
Received: by mail-wr1-f72.google.com with SMTP id k18so3349561wrw.9
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 12:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdAv7lKgnlnMnq5dqOLheLY3zrBzh9h1Kyp8yaJhNcU=;
        b=Rokn5fKWGQc1fzENvqieHROl8avWDJKOvOvakcyxK6rEsK1m/7GvzmTR/Jo2sNcE7F
         ifeHX2S/uX1BnAapo9rxrV+TZ8WKB6zJhOsHEsl8P5Vzg4cjD8LVzx1YfMqwXhQoVvzy
         AmSdk8UHwrxCbzt6/kaTCx/MQLd58Iri+dx+LQzyIyEyyCeDJeVo3KImUHfivANTxCxF
         CwAJwT8mBC672XXU4WNneQSfTWQJNn/lmxsQS/nIRAUm94teVywKWEhYyp4vGIdd5+jw
         SYki4TjCdYbqWOdTrvN7ep5Py3bNfS+OSCV8g98BRsr3UJDpiSP6HhmvxFghdR91FPkS
         G5pw==
X-Gm-Message-State: APjAAAWnf8cu0YJQg3IscL6QMMT6YdHw4+do3maB8lMRDnc/Ow2DctkM
        GnOMlXkqrqi9OrFGgT04aR5iKf21/NcGehcmQRx3harvBpvRfvrcXUzAahEgZ9MkwB3MVS7j7w/
        5nFtYY8noOA34
X-Received: by 2002:a7b:c246:: with SMTP id b6mr6741138wmj.75.1578602564088;
        Thu, 09 Jan 2020 12:42:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1t6zfqCwAvmxF4OHqO9fEvSUg0HmaguZItEhVTs8HnJAmnsgGasy5nJRLYI1VkcpABnjpog==
X-Received: by 2002:a7b:c246:: with SMTP id b6mr6741120wmj.75.1578602563882;
        Thu, 09 Jan 2020 12:42:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:bc4e:7fe8:2916:6a59? ([2001:b07:6468:f312:bc4e:7fe8:2916:6a59])
        by smtp.gmail.com with ESMTPSA id 18sm3931764wmf.1.2020.01.09.12.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 12:42:43 -0800 (PST)
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109105443-mutt-send-email-mst@kernel.org>
 <20200109161742.GC15671@xz-x1>
 <20200109113001-mutt-send-email-mst@kernel.org>
 <20200109170849.GB36997@xz-x1>
 <20200109133434-mutt-send-email-mst@kernel.org>
 <20200109193949.GG36997@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <583d04b4-73d2-0ba7-fda6-10e15071a3c4@redhat.com>
Date:   Thu, 9 Jan 2020 21:42:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109193949.GG36997@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 20:39, Peter Xu wrote:
>>
>> IIUC at the moment KVM never uses huge pages if any part of the huge page is
>> tracked.
>
> To be more precise - I think it's per-memslot.  Say, if the memslot is
> dirty tracked, then no huge page on the host on that memslot (even if
> guest used huge page over that).
> 
>> But if all parts of the page are written to then huge page
>> is used.
>
> I'm not sure of this... I think it's still in 4K granularity.

Right.  Dirty tracking always uses 4K page size.

Paolo

