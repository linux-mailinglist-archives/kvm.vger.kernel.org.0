Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B12850F2
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgJFRin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:38:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgJFRij (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 13:38:39 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 096HWTnA102630;
        Tue, 6 Oct 2020 13:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yetm3O9T97JOXDDqZxQ5H5pUsa4oUP9tp3Y6sM5yu1Q=;
 b=V3JdMzjC2w4t6EZo2zWnvhPebekmW1DovAp0bXSZJFH1GxTWi2nBrUKnTIaHNu5byHFX
 FAkTMArO5U4nrHdxtxuLlGlh1cJ1Li3d76atWTa/1WEy762fAy3vLSB036ApOTi4hK52
 aFg2BdzHE7R57AKJRFBim+YlZaOsAB49OGyObWUSaF4dPs2QuyADlyKP0oHr3/8mymwM
 etEh1r4XczQ9PO/JT0DxS2nPuM1x7Lbdlc5UqlOm2PvOenQtZwN/X0RVnfPEI1TDBefM
 VFTGvO8Yd00XgygBmj9Gv4uN3tG7EcFyxD2nV42Jf2MQaUD4K8Dz9q6W0ml9EUUFIhzm UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340uwfacn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 13:38:33 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 096HZWTc127389;
        Tue, 6 Oct 2020 13:38:32 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 340uwfacmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 13:38:32 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 096HbXbS004717;
        Tue, 6 Oct 2020 17:38:31 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 33xgx9fegc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Oct 2020 17:38:31 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 096HcU9T41812412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Oct 2020 17:38:30 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9B34112069;
        Tue,  6 Oct 2020 17:38:30 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93C64112062;
        Tue,  6 Oct 2020 17:38:28 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Oct 2020 17:38:28 +0000 (GMT)
Subject: Re: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
To:     Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
 <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
 <20201006173259.1ec36597.cohuck@redhat.com>
 <e9f6c3e1-9341-b0d0-9fb2-b34ebd19bcba@linux.ibm.com>
 <1c118c1d-8c9b-9b7b-d1ec-2080aaa1c1a3@twiddle.net>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <b715826d-dcfb-8ed3-7050-d09904d6ed40@linux.ibm.com>
Date:   Tue, 6 Oct 2020 13:38:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1c118c1d-8c9b-9b7b-d1ec-2080aaa1c1a3@twiddle.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_09:2020-10-06,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/20 1:33 PM, Richard Henderson wrote:
> On 10/6/20 11:43 AM, Matthew Rosato wrote:
>>> Looks good, but...
>>>
>>> <meta>Is there any way to coax out a more reviewable version of this
>>> via git mv?</meta>
>>>
>>
>> I tried git mv, but a diff between the old patch and the new patch looks the
>> same (other than the fact that I squashed the MAINTAINERS hit in)
> 
> git format-patch --find-renames[=<pct>]
> 
> Though I'm surprised it's not doing that by default.
> 
> r~
> 

Huh, neat.  That looks alot better, gives something that looks like:

diff --git a/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
similarity index 100%
rename from hw/s390x/s390-pci-bus.h
rename to include/hw/s390x/s390-pci-bus.h
diff --git a/hw/s390x/s390-pci-inst.h b/include/hw/s390x/s390-pci-inst.h
similarity index 100%
rename from hw/s390x/s390-pci-inst.h
rename to include/hw/s390x/s390-pci-inst.h

Thanks!

