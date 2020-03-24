Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF70190AFF
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgCXKcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:32:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34298 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727230AbgCXKcM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 06:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UV9ud81YBTwdkQ+V+gKznrai6KmGHWHqg05YLt/rhFQ=;
        b=CRFms1iJtM7+u7LYbxO4bvnbprqCHeBK/02XhtN9HgoYytJ1XnYd4xl+0DEAuiCLfi1Me8
        uJx2IbgAuEKiUA6LBLxmgfwLXrDe3EyQ+tMAbwa+lmh5rYQG2jTaMkb07+Twr5HJCHaSXa
        SkPz9NM281y5OElhV8iidD+1/e1w/0A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-9g9p4s9HOS67wuZUp4j4QA-1; Tue, 24 Mar 2020 06:32:07 -0400
X-MC-Unique: 9g9p4s9HOS67wuZUp4j4QA-1
Received: by mail-wm1-f69.google.com with SMTP id n188so1100860wmf.0
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 03:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UV9ud81YBTwdkQ+V+gKznrai6KmGHWHqg05YLt/rhFQ=;
        b=UsCoXmi3sJV519c2rXvAvX5Q9ay8DsA7n9ci+XGHv9SRu5aDwOJjaRuER9AuikvfSi
         aaE0FuqDfZ3xBVhKA/E7pcPNJ7TOKWGwj/msWNQlcTbO6OogYyVeBveciGzTo2B18QDi
         uuzsTE/VMcga0tF/U3XGSTLconNKtIxEw54j7RNZoikFcfm0Ij9UdMAbh0YoyqL0kOm2
         QlKq6qQIPHEa7ZtZNnAFodavCv76+2+lFL/5ZO2+UkQgPV54DD35yyxzsjIgG6HEQX+V
         CRPQtpSbvaZTvQlNdSozP1ysSlUpGGPB9gov8GKmXw5jh4zEtwLs1AOYySpET/zKr7mW
         20VA==
X-Gm-Message-State: ANhLgQ3eVtn5vI12BMr8ben0XDcZzJbFFXdJP82BsnxXiBAkXTvhYCNG
        I4myNrIuKWwNlolD/NRbbykEqMt7UFzt0XhkqpsEWclb9K6kkIVFeMgV+l6pyCradt9VNiQLMCn
        ZN1U55ZNqoht5
X-Received: by 2002:a5d:4085:: with SMTP id o5mr34240927wrp.327.1585045926560;
        Tue, 24 Mar 2020 03:32:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtBMvtz9k9ioXP95UpBgynAuCqmmPTYB8zbQkJXHAC4DCQ5zdb+6zmBIIMALmZ6zokl0maW0Q==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr34240898wrp.327.1585045926311;
        Tue, 24 Mar 2020 03:32:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id i21sm4026154wmb.23.2020.03.24.03.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 03:32:05 -0700 (PDT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
 <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
 <d893c37d-705c-b9a1-cf98-db997edf3bce@linux.ibm.com>
 <5c350f55-64be-43fc-237d-7f71b4e9afdc@redhat.com>
 <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0143786-04e5-a9f8-bd87-d4c06cee1856@redhat.com>
Date:   Tue, 24 Mar 2020 11:32:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7c8b614a-a7a1-d33e-8762-b06d4b2fd45b@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 09:26, Stefan Raspl wrote:
> To be able to make use of the logfiles, we'd need to have the heading appear at
> the top of each of the files.
> Couldn't find much info on how logrotate works internally, but from what I
> gathered, it seems it moves out the current logfile e.g. /var/log/kvm.log to
> become /var/log/kvm.log.1, and sends a SIGHUP to kvm_stat so that it re-opens
> /var/log/kvm.log - which would then start out with a header again.
> That should work, but can you confirm that this is what you're suggesting?
> If so: Keep the current semantics for the original logging mode, where we have
> the heading printed every 20 lines? I would assume so, as that format is better
> suited for console logs, but just in case you wanted that changed...

Yes to all. :)

Paolo

