Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8C508F59
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 20:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381501AbiDTS2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 14:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381478AbiDTS2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 14:28:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822CD1835D;
        Wed, 20 Apr 2022 11:25:27 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KIERkK020568;
        Wed, 20 Apr 2022 18:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=zp+Ix3eNj7c9d/kWWI6mZaGVdCD6hYR7Jr2HjuNTbGk=;
 b=Ek+I9/QSmBJBCruKH4G8HFie6O0shxiUyFWkuCuLHaW+nRlBDY86O1zxT0oUm4OsTz6O
 VmPBLlX5BQfc2G8V0c+vrvZgHoWEUCQpKU/wu8+VSjTPAkEdp8TXlnrImRB/XysSNgYo
 gt/LTuks4P2eqz0qael3wZCcEl56l2RW2cYVoE6DN1aH8F5jcyy2/mUUrDTBNnqx+g/b
 WkmHpRAGqunxxnRro5wrjpvHwMRH2dW0Hnu1Qe4uCtTx4gldVs/kdjhvBv9j+KxCaCDA
 GT4XucBdWcojn2F7m4WyT5ZoYtPNyOueSJ3dFS4JaJ6AGixGFAV75qyLdd1JZoWbjbyj BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjq9cg5yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:25:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KIF7fv022424;
        Wed, 20 Apr 2022 18:25:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjq9cg5xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:25:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KIDVP1024341;
        Wed, 20 Apr 2022 18:25:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8pq1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:25:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KIPKfq57147670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 18:25:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D898D5204E;
        Wed, 20 Apr 2022 18:25:20 +0000 (GMT)
Received: from osiris (unknown [9.145.42.46])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5968F52051;
        Wed, 20 Apr 2022 18:25:20 +0000 (GMT)
Date:   Wed, 20 Apr 2022 20:25:19 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Message-ID: <YmBQD278Uje6LXly@osiris>
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-2-pmorel@linux.ibm.com>
 <Yl/27Pz3pvARmIHn@osiris>
 <20220420152241.4d9edea5@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420152241.4d9edea5@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fZeCQr8DjtjTimdj4c8tRN9FIg4ahFgm
X-Proofpoint-GUID: OdpQpqICGMz8ilKcU-MrtTy03MRDGbi7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 mlxlogscore=767 adultscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 03:22:41PM +0200, Claudio Imbrenda wrote:
> On Wed, 20 Apr 2022 14:05:00 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> > > +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (!test_kvm_facility(vcpu->kvm, 11))
> > > +		return false;
> > > +
> > > +	/* A new vCPU has been hotplugged */
> > > +	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
> > > +		return true;
> > > +
> > > +	/* The real CPU backing up the vCPU moved to another socket */
> > > +	if (cpumask_test_cpu(vcpu->cpu,
> > > +			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> > > +		return true;
> > > +
> > > +	return false;
> > > +}  
> > 
> > This seems to be wrong. I'd guess that you need
> > 
> > 	if (cpumask_test_cpu(vcpu->cpu,
> > 			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> > -->		return false;
> > -->	return true;  
> 
> so if the CPU moved to a different socket, it's not a change?
> and if nothing happened, it is a change?

How do you translate the above code to your statement?
