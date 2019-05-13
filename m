Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958801BAC9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfEMQMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:12:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39008 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbfEMQMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:12:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DG9XTA088123;
        Mon, 13 May 2019 16:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rP/OPccK5WignsxLuyYpQuz4cQ7lND2uT3MRe0Mdp4I=;
 b=XdPbt2CgygTocPQLUHC3NjedbqHDRyQesGdwcmWXviPgtwjzMllFtga5+MbKneALsVs3
 yjrREvz3m+1KhMkbAmmHU5mKjCdcMwtStehqYsXSThUNUdrQ85Pni0YlFiC9dUui5B3a
 z2KCerfTz7tOQNstDjCT+osz5BehIHQznn3pH7jWBkEsFJp3S/58CJK60pzSjlH0WSkX
 xoRqvbd5U6LJ4CA/3k59DS/IZS23ZBNzazWDlXP42YLnSXI8q6dqfkXmCdzE4M5NlrSV
 ZZiGHL6HzfV1ylTaNSzC74wb8ajAmVrXK4gqEHmCqd3iAeJhWTm4xMD3ckI5cRao4+R7 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sdkwdgafm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:10:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DG9FRe128443;
        Mon, 13 May 2019 16:10:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sdmeajy04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:10:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4DGAC9w003137;
        Mon, 13 May 2019 16:10:12 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 09:10:12 -0700
Subject: Re: [RFC KVM 05/27] KVM: x86: Add handler to exit kvm isolation
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
 <1557758315-12667-6-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrXmHHjfa3tX2fxec_o165NB0qFBAG3q5i4BaKV==t7F2Q@mail.gmail.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <40427143-4d13-0583-9182-c38d51d6f9eb@oracle.com>
Date:   Mon, 13 May 2019 18:10:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrXmHHjfa3tX2fxec_o165NB0qFBAG3q5i4BaKV==t7F2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=965
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130110
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=993 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/19 5:49 PM, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>> From: Liran Alon <liran.alon@oracle.com>
>>
>> Interrupt handlers will need this handler to switch from
>> the KVM address space back to the kernel address space
>> on their prelog.
> 
> This patch doesn't appear to do anything at all.  What am I missing?
> 

Let me check. It looks like I trimmed the code invoking the handler from
IRQ (to exit isolation when there's an IRQ). Probably a bad merge at some
point. Sorry.

alex.
