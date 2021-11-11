Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30344DB49
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhKKRxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:53:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59228 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233361AbhKKRxC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 12:53:02 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABHD2w8006939;
        Thu, 11 Nov 2021 17:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=V9yVX6IY4CPqCaNqAgLBefqe37sdzWCTZT6eUzc7CPk=;
 b=TMB1+yW8v0gUOG06nd2F4gHeatozPORib4hQqwIamMtlzK07msYUtAldiFrvkRbvmQsb
 Jo8lKNcQfnFbvWyYGovPFP4dYl33vU55AeTWZZUa0L2vKycWHLJEudJUKG2DNN/gmOmG
 +6rwcm2fW70HWMSznmC6PSEf6mVMPvKqxVrRwv+8GyNhr5BAyat5Aevfk1CBWf1fTzFk
 0c3pG4KhVdjBsUvaYVOzv2FdlslWH0tcupAp0mETlG4/I+ms2KlDo8dqUAXVClf4Ovtr
 YgR6baCIExjAAsnpZgCMVgEoPyFy7n9TMiigLbqP9LYZRckf4ZkV50qgDHPC3LmyaSWq sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c97cpgrr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:50:12 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABHY8Yh004772;
        Thu, 11 Nov 2021 17:50:12 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c97cpgrqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:50:12 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABHlmWb025833;
        Thu, 11 Nov 2021 17:50:11 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 3c5hbd5097-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 17:50:11 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABHo9C134210290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 17:50:09 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5C1912405A;
        Thu, 11 Nov 2021 17:50:09 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A3DC124055;
        Thu, 11 Nov 2021 17:50:07 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.106.148])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 17:50:06 +0000 (GMT)
Message-ID: <5c061ba86d5f542380d3d99ce54c5d2331a98b8d.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 11 Nov 2021 12:50:05 -0500
In-Reply-To: <55653464-8a84-d741-1b7e-eb4a163f121f@linux.ibm.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <55653464-8a84-d741-1b7e-eb4a163f121f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6QokH7enDQWahZun9lYXc9SsjMFx-5rJ
X-Proofpoint-ORIG-GUID: _17TGEG1ID6gqBzjV1NEbHAIEsUZcfos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_06,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-11 at 17:16 +0100, Janosch Frank wrote:
> On 11/10/21 21:33, Eric Farman wrote:

...snip...

> > +	case KVM_S390_VCPU_SET_SIGP_BUSY: {
> > +		int rc;
> > +
> > +		if (!vcpu->kvm->arch.user_sigp_busy)
> > +			return -EFAULT;
> 
> Huh?
> This should be EINVAL, no?

Of course; my mistake.

> 
> > +
> > +		rc = kvm_s390_vcpu_set_sigp_busy(vcpu);
> > +		VCPU_EVENT(vcpu, 3, "SIGP: CPU %x set busy rc %x",
> > vcpu->vcpu_id, rc);
> > +
> > +		return rc;
> > +	}
> > +	case KVM_S390_VCPU_RESET_SIGP_BUSY: {
> > +		if (!vcpu->kvm->arch.user_sigp_busy)
> > +			return -EFAULT;
> 
> Same
> 
> 

