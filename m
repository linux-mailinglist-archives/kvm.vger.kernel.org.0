Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A13A722D92
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbjFERXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjFERXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:23:02 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5E799;
        Mon,  5 Jun 2023 10:23:01 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355HMksg3951694
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 10:22:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355HMksg3951694
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685985768;
        bh=dNbwMJpH98YofN6seUiE6EOuBEm/hSuJhvwQqv0+58c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kNzpVnk7Uv7Ye6YR23yAl/HYe3amoO8YRHL/v0GGB+VqYZ4z4Mc02hggwILlQR228
         MiZUeCo2FjJv+i/cTavbVn2VGWLNwCPVHWgLaFYUx9vgAg4uJNzVmIfNI1VO830rlM
         yr3yNR+d2CVo9L7byH1uZ0ZKXzX1/X2Na61qnBeyLFQHsFz1h025/I1Nos0XYOto9u
         4NY1gDvzw+GStAu0aHX09PpA5GhIUps3z6J4WveeAjw3Vz5MswdymZzvNcetJkDzGP
         OHu2wZW2gU3krCLzWYtXQcnZ+iu2v7OAmP9xCaKFZ8rxxratxkzSTFog/I3VAMU7to
         pDp01vjbMgPTg==
Message-ID: <a87319a8-f87b-7bbb-697f-eb98b6ad4875@zytor.com>
Date:   Mon, 5 Jun 2023 10:22:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So I feel obliged to throw in some defending of Xin here, mostly because 
in some of these cases I'm the perkeleen vittupää[1] and not Xin.

The other thing is that this patchset is from April and predates the 
recent FRED changes (which were unanticipated at the time); I explicitly 
asked Xin to hold off making updates until the spec had restabilized.

	-hpa

[1] https://lkml.org/lkml/2013/7/13/132
