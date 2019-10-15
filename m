Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5328ED848C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 01:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387844AbfJOXnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 19:43:21 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21487 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387830AbfJOXnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 19:43:21 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 19:43:20 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1571182079; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=F9lLo4l6DYZjDaKnp65MpjHOJ448CRPtcHFPJZ/N4AnB+MuSDK9gRfOuoZLSBmVTAHiG3+KgISzfwuEmB1tpsX/O1AQtsIimrRyfJqcxoKvrYmK4/EDAQ1ww9iKr+UcLkg7PWeJJiJC9FbNf9ZO+uWR/hC0mqSVkMGNqLnbyEZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1571182079; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=NquMdh5cqrg+w/TM1tlktRlQRtwUKUgGaymy3L81CUg=; 
        b=oJKALsYjx2vub/ii+CYC37H8/IaMIhDUoOQ7IUZh/SIlrTbzldZkjIH18x1lcgD/9OqpbOFCakx/BVGDrQoqb1XRaQAAtYPJ/UCtKVOsT4hRK2tOby52b5Yw3177+QWfYuL8fL5KF6yY5f5zDppP+GLOpW38myZPAJb+H9gJaE8=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1571182076549352.5095287510885; Tue, 15 Oct 2019 16:27:56 -0700 (PDT)
In-Reply-To: <20191015140140.34748-1-zhengxiang9@huawei.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [PATCH v19 0/5] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <157118207403.5946.11773682662828159447@37313f22b938>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     zhengxiang9@huawei.com
Cc:     pbonzini@redhat.com, mst@redhat.com, imammedo@redhat.com,
        shannon.zhaosl@gmail.com, peter.maydell@linaro.org,
        lersek@redhat.com, james.morse@arm.com, gengdongjiu@huawei.com,
        mtosatti@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        jonathan.cameron@huawei.com, xuwei5@huawei.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        linuxarm@huawei.com, wanghaibin.wang@huawei.com,
        zhengxiang9@huawei.com
Date:   Tue, 15 Oct 2019 16:27:56 -0700 (PDT)
X-ZohoMailClient: External
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDE5MTAxNTE0MDE0MC4zNDc0
OC0xLXpoZW5neGlhbmc5QGh1YXdlaS5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFpbGVkIHRo
ZSBkb2NrZXItbWluZ3dAZmVkb3JhIGJ1aWxkIHRlc3QuIFBsZWFzZSBmaW5kIHRoZSB0ZXN0aW5n
IGNvbW1hbmRzIGFuZAp0aGVpciBvdXRwdXQgYmVsb3cuIElmIHlvdSBoYXZlIERvY2tlciBpbnN0
YWxsZWQsIHlvdSBjYW4gcHJvYmFibHkgcmVwcm9kdWNlIGl0CmxvY2FsbHkuCgo9PT0gVEVTVCBT
Q1JJUFQgQkVHSU4gPT09CiMhIC9iaW4vYmFzaApleHBvcnQgQVJDSD14ODZfNjQKbWFrZSBkb2Nr
ZXItaW1hZ2UtZmVkb3JhIFY9MSBORVRXT1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0LW1pbmd3
QGZlZG9yYSBKPTE0IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKICBDQyAgICAg
IHFhcGkvcWFwaS1ldmVudHMtdHJhY2UubwogIENDICAgICAgcWFwaS9xYXBpLWV2ZW50cy10cmFu
c2FjdGlvbi5vCgpXYXJuaW5nLCB0cmVhdGVkIGFzIGVycm9yOgovdG1wL3FlbXUtdGVzdC9zcmMv
ZG9jcy9zcGVjcy9hY3BpX2hlc3RfZ2hlcy5yc3Q6OTM6RW51bWVyYXRlZCBsaXN0IGVuZHMgd2l0
aG91dCBhIGJsYW5rIGxpbmU7IHVuZXhwZWN0ZWQgdW5pbmRlbnQuCiAgQ0MgICAgICBxb2JqZWN0
L3FudW0ubwogIENDICAgICAgcW9iamVjdC9xbnVsbC5vCi0tLQogIENDICAgICAgcW9iamVjdC9q
c29uLXN0cmVhbWVyLm8KICBDQyAgICAgIHFvYmplY3QvYmxvY2stcWRpY3QubwogIENDICAgICAg
dHJhY2Uvc2ltcGxlLm8KbWFrZTogKioqIFtNYWtlZmlsZTo5OTc6IGRvY3Mvc3BlY3MvaW5kZXgu
aHRtbF0gRXJyb3IgMgptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLgpU
cmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6CiAgRmlsZSAiLi90ZXN0cy9kb2NrZXIv
ZG9ja2VyLnB5IiwgbGluZSA2NjIsIGluIDxtb2R1bGU+Ci0tLQogICAgcmFpc2UgQ2FsbGVkUHJv
Y2Vzc0Vycm9yKHJldGNvZGUsIGNtZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJyb3I6IENv
bW1hbmQgJ1snc3VkbycsICctbicsICdkb2NrZXInLCAncnVuJywgJy0tbGFiZWwnLCAnY29tLnFl
bXUuaW5zdGFuY2UudXVpZD1mMDUyMGZmYTliZDM0MGU3YWRmOTc1YWYwMTAxNmI2ZicsICctdScs
ICcxMDAxJywgJy0tc2VjdXJpdHktb3B0JywgJ3NlY2NvbXA9dW5jb25maW5lZCcsICctLXJtJywg
Jy1lJywgJ1RBUkdFVF9MSVNUPScsICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0nLCAnLWUn
LCAnVj0nLCAnLWUnLCAnSj0xNCcsICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19FTlY9Jywg
Jy1lJywgJ0NDQUNIRV9ESVI9L3Zhci90bXAvY2NhY2hlJywgJy12JywgJy9ob21lL3BhdGNoZXcv
LmNhY2hlL3FlbXUtZG9ja2VyLWNjYWNoZTovdmFyL3RtcC9jY2FjaGU6eicsICctdicsICcvdmFy
L3RtcC9wYXRjaGV3LXRlc3Rlci10bXAtXzkwbmFydWsvc3JjL2RvY2tlci1zcmMuMjAxOS0xMC0x
NS0xOS4yNi4wNy4yNDQyOTovdmFyL3RtcC9xZW11Onoscm8nLCAncWVtdTpmZWRvcmEnLCAnL3Zh
ci90bXAvcWVtdS9ydW4nLCAndGVzdC1taW5ndyddJyByZXR1cm5lZCBub24temVybyBleGl0IHN0
YXR1cyAyLgpmaWx0ZXI9LS1maWx0ZXI9bGFiZWw9Y29tLnFlbXUuaW5zdGFuY2UudXVpZD1mMDUy
MGZmYTliZDM0MGU3YWRmOTc1YWYwMTAxNmI2ZgptYWtlWzFdOiAqKiogW2RvY2tlci1ydW5dIEVy
cm9yIDEKbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgYC92YXIvdG1wL3BhdGNoZXctdGVzdGVy
LXRtcC1fOTBuYXJ1ay9zcmMnCm1ha2U6ICoqKiBbZG9ja2VyLXJ1bi10ZXN0LW1pbmd3QGZlZG9y
YV0gRXJyb3IgMgoKcmVhbCAgICAxbTQ3LjkzMXMKdXNlciAgICAwbTguMjM1cwoKClRoZSBmdWxs
IGxvZyBpcyBhdmFpbGFibGUgYXQKaHR0cDovL3BhdGNoZXcub3JnL2xvZ3MvMjAxOTEwMTUxNDAx
NDAuMzQ3NDgtMS16aGVuZ3hpYW5nOUBodWF3ZWkuY29tL3Rlc3RpbmcuZG9ja2VyLW1pbmd3QGZl
ZG9yYS8/dHlwZT1tZXNzYWdlLgotLS0KRW1haWwgZ2VuZXJhdGVkIGF1dG9tYXRpY2FsbHkgYnkg
UGF0Y2hldyBbaHR0cHM6Ly9wYXRjaGV3Lm9yZy9dLgpQbGVhc2Ugc2VuZCB5b3VyIGZlZWRiYWNr
IHRvIHBhdGNoZXctZGV2ZWxAcmVkaGF0LmNvbQ==

