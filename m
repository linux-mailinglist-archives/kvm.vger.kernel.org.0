Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC88A777E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 01:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfICXRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 19:17:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfICXRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 19:17:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NEJdl191442;
        Tue, 3 Sep 2019 23:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=apk+8zl3WQsli6AHIRTsGckTHw0kmW1CShKTDWmKzjQ=;
 b=EFvw3n4xr0LOWxxydZaYQfX2ND2r+ecMEWhnYcf6O6MT1Q+UF1ZteJUqYzVEo6u+1L9p
 qflEABL0zK9aUKITdwg27KgwgxesCcdKMSxq1MyKbypl1v7BiYILALapQNxvp0bOXxZM
 wUfCqqUyqI2PtGa98MrANruuJjriFsdMP1BCmq/eOdPVudUIkRglp/SRjDUs24KAXl/W
 t1xqsTpJ5y66rENUT4Bmzd0DrAIYsaOA3N65xQs2C4c2cG95AGPmzxiuO7UuISz9vKNl
 9Q4b3NJ6MOfLSsJQf8XyMcaYMDEFWZxpoh9kDHc9tgzJxKuq1DOBIYsroxUNXCCw7O9g Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ut1mc80c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:15:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83NEQnD072712;
        Tue, 3 Sep 2019 23:15:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2usu5215td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:15:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83NFSMj028467;
        Tue, 3 Sep 2019 23:15:28 GMT
Received: from [192.168.14.112] (/79.176.230.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 16:15:28 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: VMX: Disable posted interrupts for odd IRQs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190903142954.3429-2-graf@amazon.com>
Date:   Wed, 4 Sep 2019 02:15:23 +0300
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AD5685B6-E633-4875-AD9A-4E2822D358DD@oracle.com>
References: <20190903142954.3429-1-graf@amazon.com>
 <20190903142954.3429-2-graf@amazon.com>
To:     Alexander Graf <graf@amazon.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030233
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030233
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3 Sep 2019, at 17:29, Alexander Graf <graf@amazon.com> wrote:
>=20
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
>=20
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt

I would also mention in commit message that one can see this is also
true in KVM=E2=80=99s vLAPIC code. i.e. __apic_accept_irq() can call
kvm_x86_ops->deliver_posted_interrupt() only in case deliver-mode is
either =E2=80=9CFixed=E2=80=9D or =E2=80=9CLowPriority=E2=80=9D.=20

>=20
> Add code in the VMX PI logic to explicitly refuse to establish posted
> mappings for advanced IRQ deliver modes.
>=20
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
>=20
> Signed-off-by: Alexander Graf <graf@amazon.com>

With some small improvements I written inline below:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
> 1 file changed, 22 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..d16c4ae8f685 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7401,6 +7401,28 @@ static int vmx_update_pi_irte(struct kvm *kvm, =
unsigned int host_irq,
> 			continue;
> 		}
>=20
> +		switch (irq.delivery_mode) {
> +		case dest_Fixed:
> +		case dest_LowestPrio:
> +			break;
> +		default:
> +			/*
> +			 * For non-trivial interrupt events, we need to =
go
> +			 * through the full KVM IRQ code, so refuse to =
take
> +			 * any direct PI assignments here.
> +			 */
> +
> +			ret =3D irq_set_vcpu_affinity(host_irq, NULL);
> +			if (ret < 0) {
> +				printk(KERN_INFO
> +				   "failed to back to remapped mode, =
irq: %u\n",
> +				   host_irq);
> +				goto out;

I recommend we will chose to print here a string that is different than =
the !kvm_intr_is_single_vcpu()
case to make it easier to diagnose which case exactly failed.

-Liran

> +			}
> +
> +			continue;
> +		}
> +
> 		vcpu_info.pi_desc_addr =3D __pa(vcpu_to_pi_desc(vcpu));
> 		vcpu_info.vector =3D irq.vector;
>=20
> --=20
> 2.17.1
>=20
>=20
>=20
>=20
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>=20
>=20
>=20

