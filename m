Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075D643B75
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbfFMP3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:29:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbfFML0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 07:26:22 -0400
X-Greylist: delayed 1864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2019 07:26:20 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5DAnOoB071082;
        Thu, 13 Jun 2019 10:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=wgp7cj5gIWhGNVKXNvU3r2tQN8cWgiUhKrlM8F56c+g=;
 b=Zf/du4Xdcj4gMvx8OhplpKEfYVBLca2/955+Ow9J7w7ql/yYy+w7xZL8YUNzcyB2mvEK
 7pDp4e9JVNj16ftv9sNC1+v+RRS5y2uGhXKU7cyUyMULXuVwIBPUFsq9Y9L5vqZF5SCm
 x6WS7uorSc7OpBdGEfDcTifKJKIYNkLQXE69y2Ic0ilg5X2/28VKDvPJH6e1DqmRjFwL
 dl4E6pn6m0n6cQ6PhamH/Ocao65dEVuH/VcchqJUDjJyrRvbtmErBOzQs7QtIpx5zTf/
 cmkGRaoFrSbmrlEvXpmyzWThl0y8+EIgb6HjpBiCMzTkOYX3uNVRGGEimLeW9iDcecMw kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t04ynrnpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 10:54:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5DAss25021565;
        Thu, 13 Jun 2019 10:54:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t1jpjg18a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 10:54:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5DAsu5Y024439;
        Thu, 13 Jun 2019 10:54:56 GMT
Received: from [192.168.14.112] (/79.177.239.28)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Jun 2019 03:54:56 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190612182550.GI20308@linux.intel.com>
Date:   Thu, 13 Jun 2019 13:54:51 +0300
Cc:     Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <65D4DBEB-5A9A-457D-909B-2D31A3031607@oracle.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <20190612182550.GI20308@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=707
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906130085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=756 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906130085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 12 Jun 2019, at 21:25, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Jun 12, 2019 at 07:08:24PM +0200, Marius Hillenbrand wrote:
>> The Linux kernel has a global address space that is the same for any
>> kernel code. This address space becomes a liability in a world with
>> processor information leak vulnerabilities, such as L1TF. With the =
right
>> cache load gadget, an attacker-controlled hyperthread pair can leak
>> arbitrary data via L1TF. Disabling hyperthreading is one recommended
>> mitigation, but it comes with a large performance hit for a wide =
range
>> of workloads.
>>=20
>> An alternative mitigation is to not make certain data in the kernel
>> globally visible, but only when the kernel executes in the context of
>> the process where this data belongs to.
>>=20
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space. Page
>> tables and mappings in that region will be exclusive to one address
>> space, instead of implicitly shared between all kernel address =
spaces.
>> Any data placed in that region will be out of reach of cache load
>> gadgets that execute in different address spaces. To implement
>> process-local memory, we introduce a new interface =
kmalloc_proclocal() /
>> kfree_proclocal() that allocates and maps pages exclusively into the
>> current kernel address space. As a first use case, we move =
architectural
>> state of guest CPUs in KVM out of reach of other kernel address =
spaces.
>=20
> Can you briefly describe what types of attacks this is intended to
> mitigate?  E.g. guest-guest, userspace-guest, etc...  I don't want to
> make comments based on my potentially bad assumptions.

I think I can assist in the explanation.

Consider the following scenario:
1) Hyperthread A in CPU core runs in guest and triggers a VMExit which =
is handled by host kernel.
While hyperthread A runs VMExit handler, it populates CPU core cache / =
internal-resources (e.g. MDS buffers)
with some sensitive data it have speculatively/architecturally access.
2) During hyperthread A running on host kernel, hyperthread B on same =
CPU core runs in guest and use
some CPU speculative execution vulnerability to leak the sensitive host =
data populated by hyperthread A
in CPU core cache / internal-resources.

Current CPU microcode mitigations (L1D/MDS flush) only handle the case =
of a single hyperthread and don=E2=80=99t
provide a mechanism to mitigate this hyperthreading attack scenario.

Assuming there is some guest triggerable speculative load gadget in some =
VMExit path,
it can be used to force any data that is mapped into kernel address =
space to be loaded into CPU resource that is subject to leak.
Therefore, there were multiple attempts to reduce sensitive information =
from being mapped into the kernel address space
that is accessible by this VMExit path.

One attempt was XPFO which attempts to remove from kernel direct-map any =
page that is currently used only by userspace.
Unfortunately, XPFO currently exhibits multiple performance issues that =
*currently* makes it impractical as far as I know.

Another attempt is this patch-series which attempts to remove from one =
vCPU thread host kernel address space,
the state of vCPUs of other guests. Which is very specific but I =
personally have additional ideas on how this patch series can be further =
used.
For example, vhost-net needs to kmap entire guest memory into =
kernel-space to write ingress packets data into guest memory.
Thus, vCPU thread kernel address space now maps entire other guest =
memory which can be leaked using the technique described above.
Therefore, it should be useful to also move this kmap() to happen on =
process-local kernel virtual address region.

One could argue however that there is still a much bigger issue because =
of kernel direct-map that maps all physical pages that kernel
manage (i.e. have struct page) in kernel virtual address space. And all =
of those pages can theoretically be leaked.
However, this could be handled by complementary techniques such as =
booting host kernel with =E2=80=9Cmem=3DX=E2=80=9D and mapping guest =
memory
by directly mmap relevant portion of /dev/mem.
Which is probably what AWS does given these upstream KVM patches they =
have contributed:
bd53cb35a3e9 X86/KVM: Handle PFNs outside of kernel reach when touching =
GPTEs
e45adf665a53 KVM: Introduce a new guest mapping API
0c55671f84ff kvm, x86: Properly check whether a pfn is an MMIO or not

Also note that when using such =E2=80=9Cmem=3DX=E2=80=9D technique, you =
can also avoid performance penalties introduced by CPU microcode =
mitigations.
E.g. You can avoid doing L1D flush on VMEntry if VMExit handler run only =
in kernel and didn=E2=80=99t context-switch as you assume kernel address
space don=E2=80=99t map any host sensitive data.

It=E2=80=99s also worth mentioning that another alternative that I have =
attempted to this =E2=80=9Cmem=3DX=E2=80=9D technique
was to create an isolated address space that is only used when running =
KVM VMExit handlers.
For more information, refer to:
https://lkml.org/lkml/2019/5/13/515
(See some of my comments on that thread)

This is my 2cents on this at least.

-Liran


