Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F92E1859CE
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgCODr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:47:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbgCODr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584244046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znK5JyMcOa00UxigPb/kZHSgudvNGfSnIbLKEQkVBZo=;
        b=MyprNtRDeZ+SkywoWJ71jkVw5Kk5skyH2pgfobGPSooNzDF76Ej/BSyz84zULtITjTF4iy
        BMbK1cYKzex/AtLmGlneZRMdLWBtGrHHsj43P/LKEuTXQ3ajRDo48Tr3XoFFCi6fCxZefD
        Gzb1lTo+cPR11bDv5CwCG51TaNLWJuQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-uauQ-mE6Ph6QRvBuBD3XNQ-1; Sat, 14 Mar 2020 07:44:22 -0400
X-MC-Unique: uauQ-mE6Ph6QRvBuBD3XNQ-1
Received: by mail-wr1-f72.google.com with SMTP id v6so5778377wrg.22
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=znK5JyMcOa00UxigPb/kZHSgudvNGfSnIbLKEQkVBZo=;
        b=E9k2UPzprKhLWPNhMRoLcQZeboD//i5cyy1t6rbZOl2h7QwV2NjCTXh7XpNaWaPhe8
         vIIfGBvEB17ffbiAgWfJLg19BM06h9N/umwNlYtRFa6OHUg2TdmHDGfXPBzofzUsyqkB
         XBIZUIpOHKwFUR6o8e5I7d7aZZAToCueyFBYrL5q/t5HV4G1DPzxCIJSfWLERbbJoqA8
         IptoeXB/zWXFrtT+y0+h8pItDQAE/1hV3B/kOPi3YMtug3ZvLLEnHMK4/kuW7b0sLEQ6
         8Vmc8GULscFuCGbWcfawSlQybgIJUaWj4WL4ZiM1g8OYFSuzNEPwc7Dx6nQY2JeiLu2S
         w6CQ==
X-Gm-Message-State: ANhLgQ3gs0Tg/P1Ih2OGyEomSUjS/h61yKfm0DlAWvMGyemG2k/T+OD8
        Htk2kvcoejqsLWLXWBAC94MYwuZW9ld/05tr8efA1VNSxuPTEwPcrwgs1qDfO0y810gLgl9yJjb
        Yhi68raIZ5Nxv
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr16026780wmk.131.1584186261325;
        Sat, 14 Mar 2020 04:44:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvu8ggWrlqNgyd126lufb2YY49aCMPTQYxTmHxKtmPNrdjLSnzxdMfz3+dQZiXZj0jBjgALNw==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr16026764wmk.131.1584186261072;
        Sat, 14 Mar 2020 04:44:21 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id b5sm13248060wrw.86.2020.03.14.04.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:44:20 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
To:     Peter Xu <peterx@redhat.com>, Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, thuth@redhat.com
References: <20200310091556.4701-1-drjones@redhat.com>
 <20200311192949.GL479302@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c6604237-2618-9f6f-a3ef-42ac195ca670@redhat.com>
Date:   Sat, 14 Mar 2020 12:44:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311192949.GL479302@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/20 20:29, Peter Xu wrote:
> On Tue, Mar 10, 2020 at 10:15:52AM +0100, Andrew Jones wrote:
>>
>> Andrew Jones (4):
>>   fixup! selftests: KVM: SVM: Add vmcall test
>>   KVM: selftests: Share common API documentation
>>   KVM: selftests: Enable printf format warnings for TEST_ASSERT
>>   KVM: selftests: Use consistent message for test skipping
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> I'll rebase my further tests against this too.  Thanks!
> 

Queued, thanks.

Paolo

