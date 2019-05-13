Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55791BA78
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfEMP5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:57:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49958 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbfEMP5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:57:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DFs1hJ072718;
        Mon, 13 May 2019 15:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=IDGztZNSk3EOeDwS/6bGjcJdmBuu3X/lohbpa7Ehouo=;
 b=LlxuNk4Ll9o+8qngaWj0VqzCQgTsSXzex1axGc7UkNh6H5gn9YstC9amPWxaaDjGAGxy
 Sxa/tWIucIiMuDc5eNs8xpePwQDo9RjRHZDlx4gteU7+7qD3qJfcGlJ8jfI4p0KU2bXF
 hTrOvWE9u4F+yBZzqkpFK8w/hbkYVOGGj1HI167yYV1YLAZhrm+AGaMuoc32h1acCEu+
 Sl+LCkuMuGLucQ66wPTJ9InxMzlRKZsSsAsH/9IxUOkunfxL+CHBTWsawzGKlt1dVVMx
 tOIPcxxVfu7ZL49L746BHIKd3GBFDSYj5TXX0IQIUKLyuedXoNGVX6/hX8WvrZ3cNXni Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sdkwdg710-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 15:55:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DFtFss087063;
        Mon, 13 May 2019 15:55:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sdmeajnva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 15:55:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DFtmTB016531;
        Mon, 13 May 2019 15:55:49 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 08:55:48 -0700
Subject: Re: [RFC KVM 02/27] KVM: x86: Introduce address_space_isolation
 module parameter
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-3-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrUjLRgKH3XbZ+=pLCzPiFOV7DAvAYUvNLA7SMNkaNLEqQ@mail.gmail.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <1c541cde-a502-032a-244b-96e110507224@oracle.com>
Date:   Mon, 13 May 2019 17:55:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUjLRgKH3XbZ+=pLCzPiFOV7DAvAYUvNLA7SMNkaNLEqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/19 5:46 PM, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>> From: Liran Alon <liran.alon@oracle.com>
>>
>> Add the address_space_isolation parameter to the kvm module.
>>
>> When set to true, KVM #VMExit handlers run in isolated address space
>> which maps only KVM required code and per-VM information instead of
>> entire kernel address space.
> 
> Does the *entry* also get isolated?  If not, it seems less useful for
> side-channel mitigation.
> 

Yes, context is switched before VM entry. We switch back to kernel address
space if VM-exit handler needs it or when exiting the KVM_RUN ioctl.

alex.
