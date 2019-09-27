Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9379BC0818
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfI0O5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:57:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfI0O5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:57:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8RErfIJ071464;
        Fri, 27 Sep 2019 14:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=H3LmcF+yCTrNtS6tr5I8aVhEna5pU9BAd/yrMELdMDM=;
 b=QVhTkvuZLygM6LrPRYIy0YYtaQ4eT7hIf2iStBC+XUYgLVnHy4HAI0XR/RJhvm2eCgvC
 7wGZScDpLhrbH6m0ZORkvVp9+NHUsUbLZIL5jbVdFOspckndhvNahWrB2lc/2ISgxwJW
 G6KQcSA1S7GJwZ2tglkr9t0uOVATjbn96sKVyP6GLBolmJsXlHBoOyfXmi1EbbA8cbzF
 b36rlsieSEq2q/deKEBbgFylqax5ut4Vvv2F6RU0Z2JXHrfPKcnTAJQOhkonFOkg5QZd
 FgP2BdwVDQtz1zFfVWEae8MiqWmt9Vd5fbgjQG2fyQtB98XycT/4qweMYOh7MSF4Yv4+ tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgrjs9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 14:57:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8RErwOu100190;
        Fri, 27 Sep 2019 14:55:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v9m3f1njh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 14:55:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8REtWaP025198;
        Fri, 27 Sep 2019 14:55:32 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Sep 2019 07:55:32 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: Suggest changing commit "KVM: vmx: Introduce
 handle_unexpected_vmexit and handle WAITPKG vmexit"
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <8edd1d4c-03df-56e5-a5b1-aece3c85962a@intel.com>
Date:   Fri, 27 Sep 2019 17:55:29 +0300
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E41E337-A76D-4AE7-90A6-1CDD27AFC358@oracle.com>
References: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
 <8edd1d4c-03df-56e5-a5b1-aece3c85962a@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=846
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=927 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Sep 2019, at 5:15, Tao Xu <tao3.xu@intel.com> wrote:
>=20
> On 9/26/2019 7:24 PM, Liran Alon wrote:
>> I just reviewed the patch "KVM: vmx: Introduce =
handle_unexpected_vmexit and handle WAITPKG vmexit=E2=80=9D currently =
queued in kvm git tree
>> =
(https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org_pub=
_scm_virt_kvm_kvm.git_commit_-3Fh-3Dqueue-26id-3Dbf653b78f9608d66db174eabc=
bda7454c8fde6d5&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE=
&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3DtOlWXew8EBjyAF7RjD8oK=
fiwr3Xt-mbLH9WcmUkGa5s&s=3DoqAj0v9cdPTzfE1MLuMz5FJDv_Y3rQgaXp0-2ksmwOo&e=3D=
 )
>> It seems to me that we shouldn=E2=80=99t apply this patch in it=E2=80=99=
s current form.
>> Instead of having a common handle_unexpected_vmexit() manually =
specified for specific VMExit reasons,
>> we should rely on the functionality I have added to vmx_handle_exit() =
in case there is no valid handler for exit-reason.
>> In this case (since commit 7396d337cfadc ("KVM: x86: Return to =
userspace with internal error on unexpected exit reason=E2=80=9D),
>> an internal-error will be raised to userspace as required. Instead of =
silently skipping emulated instruction.
>> -Liran
>=20
> +Sean
>=20
> Hi Liran,
>=20
> After read your code, I understand your suggestion. But if we don't =
add exit reason for XSAVES/XRSTORS/UMWAIT/TPAUSE like this:
>=20
> @@ -5565,13 +5559,15 @@ static int (*kvm_vmx_exit_handlers[])(struct =
kvm_vcpu *vcpu) =3D {
> [...]
> -	[EXIT_REASON_XSAVES]                  =3D handle_xsaves,
> -	[EXIT_REASON_XRSTORS]                 =3D handle_xrstors,
> +	[EXIT_REASON_XSAVES]                  =3D NULL,
> +	[EXIT_REASON_XRSTORS]                 =3D NULL,
> [...]
> +	[EXIT_REASON_UMWAIT]                  =3D NULL,
> +	[EXIT_REASON_TPAUSE]                  =3D NULL,
>=20
> It is confused when someone read these code.

Why is it confusing?
Any exit-reason not specified in kvm_vmx_exit_handlers[] is an =
exit-reason KVM doesn=E2=80=99t expect to be raised from hardware.
Whether it=E2=80=99s because VMCS is configured to not raise that =
exit-reason or because it=E2=80=99s a new exit-reason only supported on =
newer CPUs.
(Which is kinda the same. Because a new exit-reason should be raised =
only if hypervisor opt-in some VMCS feature).

I think explicitly adding handlers for known exit-reasons to call =
handle_unexpected_vmexit() is confusing.
(In addition, this misaligns VMX treatment of unexpected exit-reasons =
from SVM treatment of exactly the same. Which is currently aligned).

-Liran

> So how about I move your code chunk:
>=20
> vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>                exit_reason);
> dump_vmcs();
> vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
> vcpu->run->internal.suberror =3D
>        KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> vcpu->run->internal.ndata =3D 1;
> vcpu->run->internal.data[0] =3D exit_reason;
>=20
> into handle_unexpected_vmexit(), then this function become:
>=20
> static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
> {
> 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>                exit_reason);
> 	dump_vmcs();
> 	vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
> 	vcpu->run->internal.suberror =3D
>        	KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> 	vcpu->run->internal.ndata =3D 1;
> 	vcpu->run->internal.data[0] =3D to_vmx(cpu)->exit_reason;
> 	return 0;
> }
>=20
> Then vmx_handle_exit() also can call this function.
>=20
> How about this solution?
>=20
> Tao

