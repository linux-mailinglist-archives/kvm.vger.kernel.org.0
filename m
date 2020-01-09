Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDB21361FB
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 21:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgAIUv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 15:51:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726267AbgAIUv6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 15:51:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578603116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qu8blCRDlzm/qLVFE5UR+s1TwIN4x5NgSUj8f1EJSs=;
        b=BnO6whRP49RZB2Jj4XBkd9cicr9ZFca/EHR90lPYfggbvHYitLrF0jDXcLHdYNlzl+ycsB
        Cyl4MNUVxYG5+ijn9KzQu26EsusqFcSYncP8JNispc+0czfcq91ufsGMizxBy7/yvR+V2a
        l7jrcz+vfBS/C5s2CEczOc8EEpp9OLk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-slIttvpTMMyNCREKEF2NeA-1; Thu, 09 Jan 2020 15:51:55 -0500
X-MC-Unique: slIttvpTMMyNCREKEF2NeA-1
Received: by mail-wm1-f70.google.com with SMTP id w205so1397714wmb.5
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 12:51:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+qu8blCRDlzm/qLVFE5UR+s1TwIN4x5NgSUj8f1EJSs=;
        b=jeFep5fQ2ykEeBr9QUqpYsVpZSlTZ6MAEC7Vwdh70l1KY4ZrsuEQBjPtx6vbYuj0Vz
         4YzZ9rEw7s6rLxI3qlBded5EHx9a8QCt31Hzwjo0weJR7+MUC4RltfmwqfBXGGqFWdXA
         xGM1xM92xH+BXdXrh0jw/Q8cY7z4YjXbzfevo0RWSoDcNRm6hGd+aFi4nmrGJM0N1o59
         NQOaimbjIc9qfCGdOP7ylfl8UT+DS0gdGj6qe3RFM2sWfEqrbv20N0CGq8kPXIKmXvka
         fiEETrvfH+no8ttph1B0WT3uIRgWw8WXMcIGA8F0ATds7jIk5zy7zOJ1IraBEdVv/44X
         H7Hg==
X-Gm-Message-State: APjAAAVxxuPnoUfHvZJ535eTF7ddR98uD67gxPHrTOJPzhsjGsbTH/50
        gQA8+N4r3k+y9DRATbCiz7z7bjaXseAXUsnxP2C0/oPMHTA4OPhzmfO91eaVFDXTBoMnGE0etjq
        hEZJDhMzeEUCz
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr13068437wrm.241.1578603114521;
        Thu, 09 Jan 2020 12:51:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUkc1W0JH2wPGSGgsriAl9XJ5bfYNaxAfV5pQh7ajg11nbajhVxytC/uExDq3BtxUddmlSDg==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr13068413wrm.241.1578603114251;
        Thu, 09 Jan 2020 12:51:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:bc4e:7fe8:2916:6a59? ([2001:b07:6468:f312:bc4e:7fe8:2916:6a59])
        by smtp.gmail.com with ESMTPSA id m7sm4047716wma.39.2020.01.09.12.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 12:51:53 -0800 (PST)
Subject: Re: [PATCH v3 00/21] KVM: Dirty ring interface
To:     "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109094711.00eb96b1@w520.home> <20200109175808.GC36997@xz-x1>
 <20200109140948-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <feffe012-0407-128a-185a-42cb9d5aac5c@redhat.com>
Date:   Thu, 9 Jan 2020 21:51:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109140948-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 20:13, Michael S. Tsirkin wrote:
> That's one of the reasons I called for using something
> resembling vring_packed_desc.

In principle it could make sense to use the ring-wrap detection
mechanism from vring_packed_desc instead of the producer/consumer
indices.  However, the element address/length indirection is unnecessary.

Also, unlike virtio, KVM needs to know if there are N free entries (N is
~512) before running a guest.  I'm not sure if that is possible with
ring-wrap counters, while it's trivial with producer/consumer indices.

Paolo

