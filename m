Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8771508925
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378953AbiDTNZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiDTNZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:25:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012B242A27;
        Wed, 20 Apr 2022 06:22:50 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KCDeNo024516;
        Wed, 20 Apr 2022 13:22:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kN02BilbPjciMpzpxMIq+yOFK1czBMc+s5hK9BVxh4c=;
 b=BX1RTwRzP/YV7cOaoaiVs70HelVItoebavNwqKBjIlaFutAlo5TGTWvlWNiNqn//k1PB
 7PMPiqx/xI3cX7SU3PzBckn4MSp5HGNSjMgJTth/eB+cyMPO6cwl5npJqaWAaPI0oPYF
 RCpAbEP8W+oecETvBagzzVj0n2lu9rQ00ORMrFAO3IVMcd+Yef/FvyOrTnkAn2RkxboN
 WbmVVH6Iyc3uka+AsnvSFexrI+rRL3vhHaG7MCM5Z0sErqWlDGsbb3zacB0bvq7ypBtw
 jezeqZAc+NWHuxRpOhtFCgi1oUDTLgnnOzb9QHvWqwRYliPXwJyn6n1CetQd+lf0C8Xm 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2vtn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:22:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBmBbo011980;
        Wed, 20 Apr 2022 13:22:49 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2vtm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:22:49 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KDD54S030720;
        Wed, 20 Apr 2022 13:22:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ffne951aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:22:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KDMtpr10093242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 13:22:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D9DE11C04C;
        Wed, 20 Apr 2022 13:22:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5896A11C05E;
        Wed, 20 Apr 2022 13:22:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 13:22:43 +0000 (GMT)
Date:   Wed, 20 Apr 2022 15:22:41 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Message-ID: <20220420152241.4d9edea5@p-imbrenda>
In-Reply-To: <Yl/27Pz3pvARmIHn@osiris>
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
        <20220420113430.11876-2-pmorel@linux.ibm.com>
        <Yl/27Pz3pvARmIHn@osiris>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N15tDa8gHZtPnWoR-E3XoVQBWCf4a02g
X-Proofpoint-ORIG-GUID: wrX6HMN0SUnpusW4M7c1dRW7XgatiOgq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=951 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Apr 2022 14:05:00 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> > +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
> > +{
> > +	if (!test_kvm_facility(vcpu->kvm, 11))
> > +		return false;
> > +
> > +	/* A new vCPU has been hotplugged */
> > +	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
> > +		return true;
> > +
> > +	/* The real CPU backing up the vCPU moved to another socket */
> > +	if (cpumask_test_cpu(vcpu->cpu,
> > +			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> > +		return true;
> > +
> > +	return false;
> > +}  
> 
> This seems to be wrong. I'd guess that you need
> 
> 	if (cpumask_test_cpu(vcpu->cpu,
> 			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> -->		return false;
> -->	return true;  

so if the CPU moved to a different socket, it's not a change?
and if nothing happened, it is a change?
