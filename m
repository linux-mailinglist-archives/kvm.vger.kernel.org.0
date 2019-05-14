Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2011C43F
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfENH6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:58:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfENH6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:58:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E7rWLj013371;
        Tue, 14 May 2019 07:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=Hm9Tm5LOAz3Yewu8iIsMrN/PygszNEAXdNiSHUZXasc=;
 b=Cxu0RbtnDfFw0XdHX1a2nnhh6Murm5HeXI3uwUQKENUOiWgCk+Uad2iC/dmeOx92QJ4c
 ArOiWnnJX0B4nK1vHuAdNSDrIwvsD3/DLRNjc+AfrPwlVG7eY1cpq+mQpPHLqKkSXGZM
 s3Zzb+PcTUXnnJoR0u5Vu0UtNpHoH2qD/++5S7CaEEHgYj+WZhVYhg7kpQ5gqvdiE6l6
 XxxsU8vhbvd8ChVXIr9Z9SYgOwqyAb6FiFlf+ykIotOkitY7klVomllhLJliLaJ/O8Ws
 0PBgos6GaN0Wt4URNQU2Md4SGAZ5MlFC+MM9fI6bw4HS4Mi0ylZzQx9Igug9XTnyytC3 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sdnttm1k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 07:57:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E7vHQ8144326;
        Tue, 14 May 2019 07:57:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sdmeax9ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 07:57:43 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4E7vZFf007379;
        Tue, 14 May 2019 07:57:37 GMT
Received: from [10.0.5.57] (/213.57.127.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 07:57:35 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190514072941.GG2589@hirez.programming.kicks-ass.net>
Date:   Tue, 14 May 2019 10:57:29 +0300
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F88E7218-04F2-4C86-A89E-D73695A03B0A@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
 <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
 <20190514072941.GG2589@hirez.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140058
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140058
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 May 2019, at 10:29, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>=20
> (please, wrap our emails at 78 chars)
>=20
> On Tue, May 14, 2019 at 12:08:23AM +0300, Liran Alon wrote:
>=20
>> 3) =46rom (2), we should have theoretically deduced that for every
>> #VMExit, there is a need to kick the sibling hyperthread also outside
>> of guest until the #VMExit is completed.
>=20
> That's not in fact quite true; all you have to do is send the IPI.
> Having one sibling IPI the other sibling carries enough guarantees =
that
> the receiving sibling will not execute any further guest instructions.
>=20
> That is, you don't have to wait on the VMExit to complete; you can =
just
> IPI and get on with things. Now, this is still expensive, But it is
> heaps better than doing a full sync up between siblings.
>=20

I agree.

I didn=E2=80=99t say you need to do full sync. You just need to IPI the =
sibling
hyperthreads before switching to the full kernel address space.
But you need to make sure these sibling hyperthreads don=E2=80=99t get =
back into
the guest until all hyperthreads are running with KVM isolated address =
space.

It is still very expensive if done for every #VMExit. Which as I =
explained,
can be avoided in case we use the KVM isolated address space technique.

-Liran

