Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650CC387E1B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbhERRCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:02:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232496AbhERRCS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 13:02:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IGYIva111104;
        Tue, 18 May 2021 13:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PCoxcp5ibyVLV63FLBDq4lpfHqnNx8KVKs7wAk76jCA=;
 b=s/cExPqdOlGdbG7UITyfRKOE+e83OWrU0kV5r148ArTdqNqkbB9eWQeOK90cpW3TuYlH
 tOU4JhMCVr/tCSRnoPxowmG3VV7dAE0fbr8TbcVMQYFHCXf8crzv9P39hm5bJNBzZAtx
 ezjRrubHPNZWIJmODnAVDMCTfR1w2Ymv2akBmBXnz62xnJkRGwcby4Ew9T8EInu9aazg
 hsoHe/BxjVSrhbOzINuVbkNLPbnT/ymyrh4O2yn0od3Y4LCvpFIs520Xt6pYc7ACxknG
 K4w4Czwt9lGmr0pOgQUEaASjVyLgLKzImVcKEhLHJx4YPEGVakV1UHMOLCt8o5hnT1Ol xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mg7s2ppa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:01:00 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IGZSOD120686;
        Tue, 18 May 2021 13:00:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mg7s2pkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 13:00:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IGtWk1026200;
        Tue, 18 May 2021 17:00:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x89m0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 17:00:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IH0rcB28967168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 17:00:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 081F252079;
        Tue, 18 May 2021 17:00:53 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A8AAF52065;
        Tue, 18 May 2021 17:00:50 +0000 (GMT)
Date:   Tue, 18 May 2021 19:00:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518190049.7e6e661f@ibm-vm>
In-Reply-To: <e66400c5-a1b6-c5fe-d715-c08b166a7b54@de.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
        <20210518173624.13d043e3@ibm-vm>
        <20210518180411.4abf837d.cohuck@redhat.com>
        <20210518181922.52d04c61@ibm-vm>
        <a38192d5-0868-8e07-0a34-c1615e1997fc@redhat.com>
        <20210518183131.1e0cf801@ibm-vm>
        <e66400c5-a1b6-c5fe-d715-c08b166a7b54@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o7NNWV0vowzARXZ4UsRFtxBVc6NxOltp
X-Proofpoint-ORIG-GUID: Cy_bc8bftKD4yt5A88wyc_o52gcH1XYS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_08:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105180113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 18:55:56 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.05.21 18:31, Claudio Imbrenda wrote:
> > On Tue, 18 May 2021 18:22:42 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >   
> >> On 18.05.21 18:19, Claudio Imbrenda wrote:  
> >>> On Tue, 18 May 2021 18:04:11 +0200
> >>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>      
> >>>> On Tue, 18 May 2021 17:36:24 +0200
> >>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> >>>>     
> >>>>> On Tue, 18 May 2021 17:05:37 +0200
> >>>>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>>>         
> >>>>>> On Mon, 17 May 2021 22:07:47 +0200
> >>>>>> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:  
> >>>>     
> >>>>>>> This means that the same address space can have memory
> >>>>>>> belonging to more than one protected guest, although only one
> >>>>>>> will be running, the others will in fact not even have any
> >>>>>>> CPUs.  
> >>>>>>
> >>>>>> Are those set-aside-but-not-yet-cleaned-up pages still possibly
> >>>>>> accessible in any way? I would assume that they only belong to
> >>>>>> the  
> >>>>>
> >>>>> in case of reboot: yes, they are still in the address space of
> >>>>> the guest, and can be swapped if needed
> >>>>>         
> >>>>>> 'zombie' guests, and any new or rebooted guest is a new entity
> >>>>>> that needs to get new pages?  
> >>>>>
> >>>>> the rebooted guest (normal or secure) will re-use the same pages
> >>>>> of the old guest (before or after cleanup, which is the reason
> >>>>> of patches 3 and 4)  
> >>>>
> >>>> Took a look at those patches, makes sense.
> >>>>     
> >>>>>
> >>>>> the KVM guest is not affected in case of reboot, so the
> >>>>> userspace address space is not touched.  
> >>>>
> >>>> 'guest' is a bit ambiguous here -- do you mean the vm here, and
> >>>> the actual guest above?
> >>>>     
> >>>
> >>> yes this is tricky, because there is the guest OS, which
> >>> terminates or reboots, then there is the "secure configuration"
> >>> entity, handled by the Ultravisor, and then the KVM VM
> >>>
> >>> when a secure guest reboots, the "secure configuration" is
> >>> dismantled (in this case, in a deferred way), and the KVM VM (and
> >>> its memory) is not directly affected
> >>>
> >>> what happened before was that the secure configuration was
> >>> dismantled synchronously, and then re-created.
> >>>
> >>> now instead, a new secure configuration is created using the same
> >>> KVM VM (and thus the same mm), before the old secure configuration
> >>> has been completely dismantled. hence the same KVM VM can have
> >>> multiple secure configurations associated, sharing the same
> >>> address space.
> >>>
> >>> of course, only the newest one is actually running, the other ones
> >>> are "zombies", without CPUs.
> >>>      
> >>
> >> Can a guest trigger a DoS?  
> > 
> > I don't see how
> > 
> > a guest can fill its memory and then reboot, and then fill its
> > memory again and then reboot... but that will take time, filling
> > the memory will itself clean up leftover pages from previous boots.
> >  
> 
> In essence this guest will then synchronously wait for the page to be
> exported and reimported, correct?

correct

> > "normal" reboot loops will be fast, because there won't be much
> > memory to process
> > 
> > I have actually tested mixed reboot/shutdown loops, and the system
> > behaved as you would expect when under load.  
> 
> I guess the memory will continue to be accounted to the memcg?
> Correct?

for the reboot case, yes, since the mm is not directly affected.
for the shutdown case, I'm not sure.
