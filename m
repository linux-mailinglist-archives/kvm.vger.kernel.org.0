Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279DD2A6509
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 14:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgKDNYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 08:24:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729198AbgKDNYH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 08:24:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4D4gjI057290;
        Wed, 4 Nov 2020 08:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kMS8dnRa/Hdk8pNtTJ+ALouPnU+4X+kgytqVwoqvmaI=;
 b=EGKJQBJECi6OCe2KkNFP+efDKxPBvbgAWI3TarLN502BLh2RSxoDzJzY7PSrc6aLh09Q
 GMqAQQk8UvmClbnm2aXcD+OtbSjha6BSXjE4nUHVS5shhDJW7njbormwp6tIgYkjgr65
 4mpM1Po+cWXhbOpxCbrt00C5LR4wE8qql/vcSLQptI64+BYBYRVsoTugmxRcXiYnr19P
 a1mUfVuHpMPG5carRR2ecoTGznwxKEoGisK5Zmu9rOqLVPI7g4ipt72e9mu4OVMjUn94
 U9OglYiTnLUfnGlqbFChq6toRLcP+o50cp7466El9QtEZLyUDO59FT9MxxC1d7qB8tPk 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34kqdauw3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 08:24:05 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A4D43VT053834;
        Wed, 4 Nov 2020 08:24:05 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34kqdauw2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 08:24:05 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4DGwV6016711;
        Wed, 4 Nov 2020 13:24:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6t7sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 13:24:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4DO0xC56951198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 13:24:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2649EA4055;
        Wed,  4 Nov 2020 13:24:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 782D9A4040;
        Wed,  4 Nov 2020 13:23:59 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.60.144])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 13:23:59 +0000 (GMT)
Date:   Wed, 4 Nov 2020 14:23:10 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 08/14] s390/vfio-ap: hot plug/unplug queues on
 bind/unbind of queue device
Message-ID: <20201104142310.15f9d73b.pasic@linux.ibm.com>
In-Reply-To: <055284df-87d8-507a-d7d7-05a73459322d@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-9-akrowiak@linux.ibm.com>
        <20201028145725.1a81c5cf.pasic@linux.ibm.com>
        <055284df-87d8-507a-d7d7-05a73459322d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_08:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 mlxlogscore=937 phishscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 Nov 2020 17:49:21 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > We do this to show the no queues but bits set output in show? We could
> > get rid of some code if we were to not z  

Managed to delete "eroize" fro "zeroize"

> 
> I'm not sure what you are saying/asking here. The reason for this
> is because there is no point in setting bits in the APCB if no queues
> will be made available to the guest which is the case if the APM or
> AQM are cleared.

Exactly my train of thought! There is no point doing work (here
zeroizing) that has no effect.

Also I'm leaning towards incremental updates to the shadow_apcb (instead
of basically recomputing it from the scratch each time). One thing I'm
particularly worried abut is that because of the third argument of
vfio_ap_mdev_filter_guest_matrix() called filter_apid, we could end up
with different filtering decision than previously. E.g. we decided to
filter the card on e.g. removal of a single queueu, but then somebody
does an assign domain, and suddenly we unplug the domain and plug the
card. With incremental changes the shadow_apcb, we could do less work
(revise only what needs to be), and it would be more straight forward
to reason about the absence of inconsistent filtering.

Regards,
Halil
