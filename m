Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3888D1528C8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBEKB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 05:01:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727068AbgBEKB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 05:01:58 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0159tCTf051843
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 05:01:56 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhn2gys5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 05:01:56 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 5 Feb 2020 10:01:54 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 10:01:51 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015A1nvh48955596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 10:01:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 768B9AE057;
        Wed,  5 Feb 2020 10:01:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27BF1AE04D;
        Wed,  5 Feb 2020 10:01:49 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 10:01:49 +0000 (GMT)
Subject: Re: [RFCv2 08/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-9-borntraeger@de.ibm.com>
 <8fdcbfc6-3e58-8970-416f-4039bb151394@redhat.com>
 <6b4264ed-af75-53e0-a59d-94d8b5ff22e5@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 5 Feb 2020 11:01:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6b4264ed-af75-53e0-a59d-94d8b5ff22e5@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WimYpId0ZCggnAUktK63nZDu90y8CLin8"
X-TM-AS-GCONF: 00
x-cbid: 20020510-4275-0000-0000-0000039E1CD2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020510-4276-0000-0000-000038B2467E
Message-Id: <215dbc53-0a21-365f-62a5-ea2389fdffe8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_02:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=3 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WimYpId0ZCggnAUktK63nZDu90y8CLin8
Content-Type: multipart/mixed; boundary="j7D7x5JkBIusWs5UBSj6WyD9ESzrnw3xR"

--j7D7x5JkBIusWs5UBSj6WyD9ESzrnw3xR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/4/20 1:34 PM, Christian Borntraeger wrote:
>=20
>=20
> On 04.02.20 13:13, David Hildenbrand wrote:
>> [...]
>>
>>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>>> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cm=
d)
>>> +{
>>> +	int r =3D 0;
>>> +	void __user *argp =3D (void __user *)cmd->data;
>>> +
>>> +	switch (cmd->cmd) {
>>> +	case KVM_PV_VM_CREATE: {
>>> +		r =3D -EINVAL;
>>> +		if (kvm_s390_pv_is_protected(kvm))
>>> +			break;
>>> +
>>> +		r =3D kvm_s390_pv_alloc_vm(kvm);
>>> +		if (r)
>>> +			break;
>>> +
>>> +		mutex_lock(&kvm->lock);
>>> +		kvm_s390_vcpu_block_all(kvm);
>>> +		/* FMT 4 SIE needs esca */
>>> +		r =3D sca_switch_to_extended(kvm);
>>> +		if (!r)
>>> +			r =3D kvm_s390_pv_create_vm(kvm);
>>> +		kvm_s390_vcpu_unblock_all(kvm);
>>> +		mutex_unlock(&kvm->lock);
>>> +		break;
>>> +	}
>>
>> I think KVM_PV_VM_ENABLE/KVM_PV_VM_DISABLE would be a better fit. You'=
re
>> not creating/deleting VMs, aren't you? All you're doing is allocating
>> some data and performing some kind of a mode switch.
>=20
> I kind of like the idea. Need to talk to Janosch about this.=20
>> [...]
>>
>>>  	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, =
vcpu,
>>>  		 vcpu->arch.sie_block);
>>>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
>>> @@ -4353,6 +4502,37 @@ long kvm_arch_vcpu_async_ioctl(struct file *fi=
lp,
>>>  	return -ENOIOCTLCMD;
>>>  }
>>> =20
>>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>>> +static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
>>> +				   struct kvm_pv_cmd *cmd)
>>> +{
>>> +	int r =3D 0;
>>> +
>>> +	if (!kvm_s390_pv_is_protected(vcpu->kvm))
>>> +		return -EINVAL;
>>> +
>>> +	switch (cmd->cmd) {
>>> +	case KVM_PV_VCPU_CREATE: {
>>> +		if (kvm_s390_pv_handle_cpu(vcpu))
>>> +			return -EINVAL;
>>> +
>>> +		r =3D kvm_s390_pv_create_cpu(vcpu);
>>> +		break;
>>> +	}
>>> +	case KVM_PV_VCPU_DESTROY: {
>>> +		if (!kvm_s390_pv_handle_cpu(vcpu))
>>> +			return -EINVAL;
>>> +
>>> +		r =3D kvm_s390_pv_destroy_cpu(vcpu);
>>> +		break;
>>> +	}
>>> +	default:
>>> +		r =3D -ENOTTY;
>>> +	}
>>> +	return r;
>>> +}
>>
>> I asked this already and didn't get an answer (lost in the flood of
>> comments :) )
>>
>> Can't we simply convert all VCPUs via KVM_PV_VM_CREATE and destoy them=

>> via KVM_PV_VM_DESTROY? Then you can easily handle hotplug as well in t=
he
>> kernel when a new VCPU is created and PV is active - oh and I see you
>> are already doing that in kvm_arch_vcpu_create(). So that screams for
>> doing either this a) completely triggered by user space or b) complete=
ly
>> in the kernel. I prefer the latter. One interface less required.
>>
>> I would assume that no VCPU is allowed to be running inside KVM while
>=20
> right.
>=20
>> performing the PV switch, which would make this even easier.
>=20
> Same as above. I like the idea. Will need to talk to Janosch.=20

My initial code had a global VM switch and I quickly ran into the
problems of the complexity that such a solution poses.

The benefits of splitting were:
	* Less time spend in kernel for one single ioctl
	* Error handling can be split up into VM and VCPU (my biggest problem
initially)
	* Error reporting is more granular (i.e. ioctl returns error for VCPU
or VM)
	* It's in line with KVM's concept of VCPUs and VMs where we create the
VM and then each VCPU




--j7D7x5JkBIusWs5UBSj6WyD9ESzrnw3xR--

--WimYpId0ZCggnAUktK63nZDu90y8CLin8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl46kowACgkQ41TmuOI4
ufhb1BAAxkm2hvPs+j0acJyZQQ18rUn10QT1wTlIdz6q+0ywcs7LEXlKZSF7JWP8
byRFof2gZaXcNmGWahPgO7Lyn2kZSgw0NJDZt7MKAZb3/gwKIgPdL7Oj1VwvOmLj
y9+4rVB0lvezn5Eg3fnBjhMIjIiZkdP7nFTsOckK1DBR7BXTR23uxskHxZSIiRjG
qlivAzQirhxpla3fCn7KEUtCZnFKs+AtzP3nmiCN9R5LiXHUYv66KEGByLP7dH67
UvuguyKoaclwB4jsOWZFfLjCyTD2dPBg2DuMLITpjCCkOncqtQyVDjH1BQGLdh3l
dIRJhxoXt582cxjOtMIkFkdA1fB2yS0jqqK6sxmpIyUOOpjd5F/CmaxK1qvaf/Nm
PU+VjxfgCBxVOOvDpRYiX3ZwXmL1HjoClPanIIisvb//zomVvYtbzSg7Fdkm6Y+0
Pr96skmpY1iaAd+dsIqPT3qVKjrvlOmMFE0TJuyC/ONeu1l0AO6H2bp/fyZyFvh3
iwLbJKdNQxGgLvCHL7pXyWlPpEPRXEWO5hOr9IhU5z1qoYxhBkJuxZqXzL34K72q
tFeG02p9eZPWGfTLRynPtKq+CLfpQtgfBAA86CAlYyL3z2XoPKCC5FCbWYoXrrKM
iAq84WWGpEYAAJL9d/4zTyH/5cUZ5QjnZF5FA+iTWxm5IK7AbfQ=
=+RQK
-----END PGP SIGNATURE-----

--WimYpId0ZCggnAUktK63nZDu90y8CLin8--

