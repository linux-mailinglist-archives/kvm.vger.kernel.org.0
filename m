Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768EA173F78
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1SYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:24:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgB1SYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 13:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582914251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMXUTpAUZ6TaurYc4NjToGDpMrs1S9QhtbrFq3PR8xM=;
        b=TSm/415LZXN/mxTQqW96I6ouypJymgJxxqUC+jx+xX8rz0y2M9SqTRDDTXMPF14wYFpgpd
        0X3MFyQyGgZDIFv8XIk5fKe17ScQM/GMJZRLgwxCMG3pApbFZ6bSwOSqdqnTvPm8wSLStU
        2Y9I+qb0yx7fTcM5Efj/oxutIiexuVA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-7FU-eAO_O-i5Uz6zrtYUsg-1; Fri, 28 Feb 2020 13:24:09 -0500
X-MC-Unique: 7FU-eAO_O-i5Uz6zrtYUsg-1
Received: by mail-wm1-f72.google.com with SMTP id q20so431831wmg.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 10:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mMXUTpAUZ6TaurYc4NjToGDpMrs1S9QhtbrFq3PR8xM=;
        b=r38DoE2zYNSHCAaiGTGJ0QhE22SOY3YR5Wz90O0IBDXrjxm5SOi2SQO4WM2F4JDlcH
         TBY5rpcUdhhw7ehmWbZ4Sw5Z8oNBQl/Hf3q0qh8dXlLV5rhHXjJ6bNQCJDt0rjX9FJoP
         hsXytdcmjjwf5i5+Myy5C9P8qLlafH70qF45WfFUwxAzVgx9vcR3hqVjKbxumYAMV0NT
         iOhQc8RK61uyM5F2Vi308OtioOj8Oeu0K28kPYSn4ANaxyFSb1mKA0CqrSuMicxwdX79
         aujhdHtcYmyPUPPOuxzLNU6yAvuOGnY6JniRx6LS8OexTRIlefReCHMly3vF9Hd32Qf9
         2+Dg==
X-Gm-Message-State: APjAAAXtZoOFHKhkqGJ9YJoIpRfYkulYr17d1qXrapwB97MqjCaQKeR1
        zADHVhdtMzf8DNvmLNwj5aYmQx3PaR9HchmIknFDfgPv+knEi7NjIdTiBFoN6G1V0mEZlkRMbZ1
        Bt25sp/yTVIh9
X-Received: by 2002:a05:600c:145:: with SMTP id w5mr5738659wmm.157.1582914248769;
        Fri, 28 Feb 2020 10:24:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkiQlyo/XFrGlCsxrm3u0aJebpwi0f3+6LQvm6zdlaE5zqDVB5dIDg1mpJXspHCj+o2w23FA==
X-Received: by 2002:a05:600c:145:: with SMTP id w5mr5738648wmm.157.1582914248512;
        Fri, 28 Feb 2020 10:24:08 -0800 (PST)
Received: from [192.168.178.40] ([151.20.130.54])
        by smtp.gmail.com with ESMTPSA id v7sm5776559wrm.49.2020.02.28.10.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 10:24:07 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: the "noclone" attribute is
 gcc-specific
To:     Oliver Upton <oupton@google.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        drjones@redhat.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-15-morbo@google.com>
 <643086be-7251-92cf-c9f5-5a467dd2827d@redhat.com>
 <CAOQ_QsjZKp3nou31jAxASojspTGbO50ZfMV_yy61rxmAwJYFsQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a9f4e8a-c2d7-3e1f-c5b6-b3bcfd43ca54@redhat.com>
Date:   Fri, 28 Feb 2020 19:24:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsjZKp3nou31jAxASojspTGbO50ZfMV_yy61rxmAwJYFsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 19:19, Oliver Upton wrote:
> If we wanted to be absolutely certain that the extern labels used for
> assertions about the guest RIP are correct, we may still want it.
> Alternatively, I could rewrite the test such that the guest will
> report the instruction boundary where it anticipates MTF whenever it
> makes the vmcall to request the host turns on MTF.

Right, but it's used only once, and as a function pointer at that, so
there's only so much that the compiler can do to "optimize".  Let's
think about how to fix it if it breaks.

Paolo

