Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21651A8018
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404196AbgDNOn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:43:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23297 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403851AbgDNOnx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 10:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586875432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jlDwdrLJ5x5+sCsQGJRT8xdwx75OLF1XYi4IwRkjJYg=;
        b=Id+tH1zY88bC+ST81+LvDcodeRm2M32AccSkkmc4w4it7QujL86eHVl6iZA1p6e1MquwIH
        8YhcnuS9JCL2RpdHV1MQyMjfteinFJqcqTDHWwp+DUQ/oY9N47LMn//h4sMbceddu326QQ
        Z80zvDMAmVBABklllpeLcOmWHpULHXE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-qMHcgSMsMJagec2yRPFIEg-1; Tue, 14 Apr 2020 10:43:50 -0400
X-MC-Unique: qMHcgSMsMJagec2yRPFIEg-1
Received: by mail-wr1-f70.google.com with SMTP id f15so8862128wrj.2
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:43:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jlDwdrLJ5x5+sCsQGJRT8xdwx75OLF1XYi4IwRkjJYg=;
        b=DK2E40JrM2ME+sY60zsUddns0EYLEw+OZHzG/NO/FROeJSP2Cy6kY9GgKzuzrlraZE
         XRsr9gH1KU7X9GJ96XlSNZlm31yRs/UplBRITFGyrHtFcundRXCQlSv4y8Y6ZmZ+E9TV
         7XsZbSlbIgHC84Ec68FTAhdq0REfKQGFnYJ5P9dEtDoUuQ9cc9FxScmMWJKG8SWc1jku
         3Uor+odvdP4cqmBWyrqRtrSRz4Dx7IRlJKac7W62ML6SA1YR3Q1xZqlZ6IqPOenW9L/u
         JKm9ygNY6X5vhF8bgOqG5l9ryK97THc7jsASqkZIolV6MHUU+1q4tnhFs307jlSruyjE
         Sg5g==
X-Gm-Message-State: AGi0PuYi+lZL9Bw1W6u2gVt5TyDsL/1rM8Cct8SNwMYPSW9rU6zIW+Qk
        cSUOfJ9IGlS5A9eSlD0sX6TWbMntBJRgtfGCByoW1+86UHFay/JUmZxA6pTHf/lZ68fK+KUVtVP
        ovfiQfLuSYOmJ
X-Received: by 2002:a5d:428a:: with SMTP id k10mr24198031wrq.59.1586875429557;
        Tue, 14 Apr 2020 07:43:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKLJ1MG28dcuTenJlSZKRRhf9VDe1WraoAmTDWxoi/HR6X+eRnfi1EHhPI2ipWYNzsHbrosbA==
X-Received: by 2002:a5d:428a:: with SMTP id k10mr24198021wrq.59.1586875429358;
        Tue, 14 Apr 2020 07:43:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o13sm19810830wrm.74.2020.04.14.07.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:43:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] ioapic-split: fix hang, run with -smp 4
In-Reply-To: <d7105f07-5a8e-41d2-01cc-841590bebb06@redhat.com>
References: <20200414141147.13028-1-pbonzini@redhat.com> <873696yw9o.fsf@vitty.brq.redhat.com> <d7105f07-5a8e-41d2-01cc-841590bebb06@redhat.com>
Date:   Tue, 14 Apr 2020 16:43:48 +0200
Message-ID: <87zhbexh3v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 14/04/20 16:30, Vitaly Kuznetsov wrote:
>> Thank you but this particular change causes the test to start failing
>> for me:
>
> Yes, it's in the commit message.  Technically it's not _starting_ to
> fail, since it was hanging before!
>

Ah, sorry for the noise, I rushed into testing without reading the
message. Just like usual)

-- 
Vitaly

